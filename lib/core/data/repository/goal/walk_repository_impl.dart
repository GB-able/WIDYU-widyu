import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/goal/walk/walk_detail.dart';
import 'package:widyu/core/model/goal/walk/walk_sync_result.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';

class WalkRepositoryImpl implements WalkRepository {
  WalkRepositoryImpl({
    required WalkLocalDataSource localDataSource,
    required WalkRemoteDataSource remoteDataSource,
    this.now = DateTime.now,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final WalkLocalDataSource _localDataSource;
  final WalkRemoteDataSource _remoteDataSource;
  final DateTime Function() now;
  final TokenManager _tokenManager = TokenManager();

  final _todaySteps = BehaviorSubject<int>.seeded(0);
  String? _date;
  int _steps = 0;
  int? _lastCount;
  String? _lastCountDate;
  int _lastCountSteps = 0;
  ({String date, int count, int steps})? _savedLive;
  int? _goal;
  String? _offsetDate;
  int _offset = 0;
  bool _disposed = false;
  final _syncRequests = StreamController<void>.broadcast();
  Future<void>? _reading;
  String? _achievedDate;
  DateTime? _achievedRequestedAt;

  // 재생되는 마지막 값이 어제 것일 수 있어 받는 시점의 날짜로 다시 계산한다.
  @override
  Stream<int> get todaySteps =>
      _todaySteps.stream.map((_) => currentTodaySteps);

  @override
  int get currentTodaySteps => _date == now().walkDate ? _steps : 0;

  void _emit() {
    if (_disposed) return;
    _todaySteps.add(currentTodaySteps);
  }

  @override
  Stream<void> get syncRequests => _syncRequests.stream;

  @override
  void dispose() {
    _disposed = true;
    _todaySteps.close();
    _syncRequests.close();
  }

  @override
  Future<bool> ensurePermission() => _localDataSource.ensurePermission();

  @override
  Future<bool> hasPermission() => _localDataSource.canReadInBackground();

  @override
  Stream<int> get liveStepCounts => _localDataSource.liveStepCounts;

  @override
  void applyLiveCount(int count) {
    if (_disposed) return;
    final today = now().walkDate;
    final last = _lastCountDate == today ? _lastCount : null;
    if (_goal != null) {
      final saved = _savedLive;
      if (last != null && count > last) {
        _raise(currentTodaySteps + count - last, live: true);
      } else if (last == null &&
          saved != null &&
          saved.date == today &&
          count >= saved.count) {
        _raise(saved.steps + count - saved.count, live: true);
      }
      _savedLive = null;
    }
    _lastCount = count;
    _lastCountDate = today;
    _lastCountSteps = currentTodaySteps;
  }

  @override
  Future<void> refreshTodaySteps() {
    if (_disposed || _goal == null) return Future.value();
    _syncIfAchieved();
    return _reading ??=
        _refreshTodaySteps().whenComplete(() => _reading = null);
  }

  Future<void> _refreshTodaySteps() async {
    final instant = now();
    final today = instant.walkDate;
    int? steps;
    try {
      steps = await _localDataSource.readSteps(today.walkStartOf, instant);
    } catch (_) {
      return;
    }
    if (_disposed) return;
    if (steps == null || steps < 0) {
      if (_date != today) _emit();
      return;
    }
    _raise(steps + (_offsetDate == today ? _offset : 0));
  }

  void _raise(int steps, {bool live = false}) {
    if (_disposed) return;
    final today = now().walkDate;
    if (_date == today && steps <= _steps) return;
    _date = today;
    _steps = steps;
    if (!live) _lastCount = null;
    _emit();
    _syncIfAchieved();
  }

  void _syncIfAchieved() {
    final goal = _goal;
    final instant = now();
    final requestedAt = _achievedRequestedAt;
    if (_disposed ||
        goal == null ||
        currentTodaySteps < goal ||
        _achievedDate == instant.walkDate ||
        (requestedAt != null &&
            instant.difference(requestedAt) < const Duration(minutes: 1))) {
      return;
    }
    _achievedRequestedAt = instant;
    _syncRequests.add(null);
  }

  @override
  Future<WalkSaveResult> sync({
    required String memberId,
    bool full = false,
    bool Function()? isCancelled,
    bool background = false,
  }) async {
    final result = await _sync(
      memberId: memberId,
      full: full,
      isCancelled: isCancelled,
      background: background,
    );
    final steps = result.steps;
    if (result.date == now().walkDate && steps != null) _raise(steps);
    return result;
  }

  @override
  void applyServerSteps(int serverSteps, {required String date, int? goal}) {
    if (_disposed) return;
    if (goal != null) {
      _goal = goal > 0 ? goal : null;
      _syncIfAchieved();
    }
    if (_goal == null || date != now().walkDate || serverSteps < 0) return;
    _raise(serverSteps);
  }

  Future<WalkSaveResult> _sync({
    required String memberId,
    required bool full,
    required bool Function()? isCancelled,
    required bool background,
  }) async {
    final budget = background && Platform.isIOS
        ? const Duration(seconds: 18)
        : const Duration(seconds: 70);
    final elapsed = Stopwatch()..start();
    final readHealth =
        !background || await _localDataSource.canReadInBackground();
    final owner = await _localDataSource.acquireLock('steps');
    if (owner == null) return const WalkSaveResult();
    Future<bool> active() async =>
        isCancelled?.call() != true &&
        elapsed.elapsed < budget &&
        await _localDataSource.ownsLock('steps', owner) &&
        await _tokenManager.memberId == memberId;
    try {
      if (!await active()) return const WalkSaveResult();
      final serverDate = now().walkDate;
      final WalkDetail? detail;
      try {
        final response = await _remoteDataSource.fetchToday();
        final status = response.statusCode ?? 0;
        if (status == 401) return const WalkSaveResult(unauthorized: true);
        if (status < 200 || status >= 300) {
          return const WalkSaveResult(retry: true);
        }
        detail = response.data;
      } catch (_) {
        return const WalkSaveResult(retry: true);
      }
      if (now().walkDate != serverDate) return const WalkSaveResult();
      _goal = detail != null && detail.goal > 0 ? detail.goal : null;
      if (detail == null || _goal == null || !await active()) {
        return const WalkSaveResult();
      }
      final state = await _localDataSource.readState(memberId);
      Future<void> save() async {
        if (await active()) {
          await _localDataSource.saveState(memberId, state);
        }
      }

      if (!await _readAndSaveSteps(
        state: state,
        serverDate: serverDate,
        serverSteps: detail.actual,
        full: full,
        readHealth: readHealth,
        active: active,
        hasReadBudget: () =>
            elapsed.elapsed <= budget - const Duration(seconds: 6),
        save: save,
      )) {
        return const WalkSaveResult();
      }
      final days = state['days'] as Map<String, dynamic>;
      final summary = await _uploadAndSaveSteps(
        days: days,
        serverDate: serverDate,
        serverSteps: detail.actual,
        active: active,
        save: save,
      );
      if (await _tokenManager.memberId != memberId ||
          isCancelled?.call() == true ||
          !await _localDataSource.ownsLock('steps', owner)) {
        return const WalkSaveResult();
      }
      final sentToday = (days[serverDate] as Map?)?['sent'] as int? ?? 0;
      if (math.max(sentToday, detail.actual) >= detail.goal) {
        _achievedDate = serverDate;
      }
      final resultDate = now().walkDate;
      return WalkSaveResult(
        date: resultDate,
        steps: (days[resultDate] as Map?)?['total'] as int?,
        uploaded: summary.uploaded,
        rewardChanged: summary.rewardChanged,
        unauthorized: summary.unauthorized,
        retry: summary.retry,
      );
    } finally {
      await _localDataSource.releaseLock('steps', owner);
    }
  }

  Future<bool> _readAndSaveSteps({
    required Map<String, dynamic> state,
    required String serverDate,
    required int serverSteps,
    required bool full,
    required bool readHealth,
    required Future<bool> Function() active,
    required bool Function() hasReadBudget,
    required Future<void> Function() save,
  }) async {
    if ((state['source'] ?? 'health') != _localDataSource.stepSource) {
      state['days'] = <String, dynamic>{};
      state['reads'] = <String, dynamic>{};
    }
    state['source'] = _localDataSource.stepSource;
    final days = Map<String, dynamic>.from(state['days'] as Map? ?? {});
    final today = now().walkDate;
    days.removeWhere((date, _) => !date.isWalkDateAllowed(now()));
    final reads = Map<String, dynamic>.from(state['reads'] as Map? ?? {});
    reads.removeWhere((date, _) => !date.isWalkDateAllowed(now()));
    final dates = now()
        .walkDateWindow
        .reversed
        .where(
          (date) =>
              full ||
              (reads[date] as int? ?? 0) <= now().millisecondsSinceEpoch,
        )
        .toList();
    state['days'] = days;
    state['reads'] = reads;
    if (days[serverDate]
        case {'liveCount': final int count, 'liveSteps': final int steps}) {
      _savedLive = (date: serverDate, count: count, steps: steps);
    }

    for (final date in dates) {
      if (!readHealth) break;
      if (!await active() || !hasReadBudget()) {
        break;
      }
      if (!date.isWalkDateAllowed(now())) continue;
      final start = date.walkStartOf;
      final nextDay = date.walkDateShift(1).walkStartOf;
      final instant = now();
      final end = nextDay.isBefore(instant) ? nextDay : instant;
      if (!end.isAfter(start)) continue;
      int? total;
      try {
        total = await _localDataSource
            .readSteps(start, end)
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        total = null;
      }
      if (!await active()) return false;
      final nextRead = _nextReadAt(date: date, today: today, total: total);
      reads[date] = nextRead.millisecondsSinceEpoch;
      if (total != null && total >= 0) {
        final day = Map<String, dynamic>.from(days[date] as Map? ?? {});
        final isServerDate = date == serverDate;
        if (isServerDate &&
            !days.containsKey(date) &&
            serverSteps > total &&
            !await _localDataSource.hasDayInAnyState(date)) {
          day['offset'] = _localDataSource.stepSource == 'recordingApi'
              ? serverSteps
              : serverSteps - total;
        }
        final offset = day['offset'] as int? ?? 0;
        day['total'] = [
          day['total'] as int? ?? 0,
          total + offset,
          if (isServerDate) ...[serverSteps, currentTodaySteps],
        ].reduce(math.max);
        days[date] = day;
        if (isServerDate) {
          _offsetDate = date;
          _offset = offset;
        }
      }
      await save();
    }
    days.removeWhere((date, _) => !date.isWalkDateAllowed(now()));
    final lastCount = _lastCount;
    if (days[serverDate] case final Map<String, dynamic> day
        when lastCount != null && _lastCountDate == serverDate) {
      day['liveCount'] = lastCount;
      day['liveSteps'] = _lastCountSteps;
    }
    await save();
    return true;
  }

  DateTime _nextReadAt({
    required String date,
    required String today,
    required int? total,
  }) {
    if (date == today) return now().add(const Duration(minutes: 1));
    if (date == today.walkDateShift(-1)) {
      return now().add(const Duration(minutes: 15));
    }
    if (total == null || total < 0) {
      return now().add(const Duration(hours: 1));
    }
    return today.walkDateShift(1).walkStartOf;
  }

  Future<({int uploaded, bool rewardChanged, bool unauthorized, bool retry})>
      _uploadAndSaveSteps({
    required Map<String, dynamic> days,
    required String serverDate,
    required int serverSteps,
    required Future<bool> Function() active,
    required Future<void> Function() save,
  }) async {
    var uploaded = 0;
    var rewardChanged = false;
    var unauthorized = false;
    var retry = false;
    for (final date in days.keys.toList()..sort()) {
      if (!await active()) {
        retry = true;
        break;
      }
      if (!date.isWalkDateAllowed(now())) {
        days.remove(date);
        await save();
        continue;
      }
      final day = days[date] as Map<String, dynamic>;
      final total = day['total'] as int;
      if (total == day['sent'] ||
          (date == serverDate && total <= serverSteps)) {
        continue;
      }
      final result = await _syncDay(date: date, steps: total);
      if (result.status == WalkSyncStatus.unauthorized) {
        unauthorized = true;
        break;
      }
      if (!await active()) {
        retry = true;
        break;
      }
      if (result.status == WalkSyncStatus.success) {
        uploaded++;
        rewardChanged |= result.achieved && day['achieved'] != true;
        day['sent'] = total;
        if (result.achieved) day['achieved'] = true;
        await save();
      } else {
        retry = true;
      }
    }
    return (
      uploaded: uploaded,
      rewardChanged: rewardChanged,
      unauthorized: unauthorized,
      retry: retry,
    );
  }

  Future<WalkSyncResult> _syncDay({
    required String date,
    required int steps,
  }) async {
    try {
      final response = await _remoteDataSource.sync(steps: steps, date: date);
      final status = response.statusCode ?? 0;
      final data = response.data;
      if (status == 401) {
        return const WalkSyncResult(WalkSyncStatus.unauthorized);
      } else if (status >= 200 && status < 300 && data != null) {
        return WalkSyncResult(
          WalkSyncStatus.success,
          achieved: data.achieved,
        );
      } else {
        return const WalkSyncResult(WalkSyncStatus.retry);
      }
    } on DioException catch (error) {
      return WalkSyncResult(
        error.response?.statusCode == 401
            ? WalkSyncStatus.unauthorized
            : WalkSyncStatus.retry,
      );
    } catch (_) {
      return const WalkSyncResult(WalkSyncStatus.retry);
    }
  }
}
