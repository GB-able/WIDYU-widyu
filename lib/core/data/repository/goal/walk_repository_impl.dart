import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
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
  int? _steps;
  bool _hasHealthSteps = false;
  bool _disposed = false;
  final _syncRequests = StreamController<void>.broadcast();
  Future<void>? _reading;
  int? _goal;
  int? _anchorSteps;
  int? _anchorCount;
  int? _lastCount;
  String? _achievedSyncDate;
  String? _liveCrossDate;

  // 재생되는 마지막 값이 어제 것일 수 있어 받는 시점의 날짜로 다시 계산한다.
  @override
  Stream<int> get todaySteps =>
      _todaySteps.stream.map((_) => currentTodaySteps);

  @override
  int get currentTodaySteps => _date == now().walkDate ? _steps ?? 0 : 0;

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
  Stream<int> get liveStepCounts => _localDataSource.liveStepCounts;

  @override
  void applyLiveCount(int count) {
    if (_disposed) return;
    _resetIfDayChanged();
    _lastCount = count;
    var anchorSteps = _anchorSteps;
    if (anchorSteps == null) {
      _anchorSteps = anchorSteps = _steps ?? 0;
      _anchorCount = count;
    }
    var anchorCount = _anchorCount;
    if (anchorCount == null || count < anchorCount) {
      _anchorCount = anchorCount = count;
    }
    final steps = anchorSteps + (count - anchorCount);
    _steps = steps;
    _emit();
    final goal = _goal;
    final today = now().walkDate;
    if (goal != null &&
        goal > 0 &&
        steps >= goal &&
        anchorSteps < goal &&
        _liveCrossDate != today) {
      _liveCrossDate = today;
      unawaited(refreshTodaySteps());
    }
  }

  @override
  Future<void> refreshTodaySteps() {
    if (_disposed) return Future.value();
    return _reading ??= _refreshTodaySteps().whenComplete(() => _reading = null);
  }

  Future<void> _refreshTodaySteps() async {
    _resetIfDayChanged();
    final instant = now();
    int? steps;
    try {
      steps = await _localDataSource.readSteps(
        instant.walkDate.walkStartOf,
        instant,
      );
    } catch (_) {
      return;
    }
    if (_disposed || steps == null || steps < 0) return;
    _anchor(steps);
  }

  // 건강값이 폰 센서보다 큰 동안(예: 워치 걸음) 실시간으로 올라간 표시가
  // 재앵커 때 되돌아가지 않도록 현재 표시값을 하한으로 둔다.
  void _anchor(int steps) {
    _date = now().walkDate;
    _anchorSteps = math.max(steps, _steps ?? 0);
    _anchorCount = _lastCount;
    _steps = _anchorSteps;
    _hasHealthSteps = true;
    _emit();
    _syncIfAchieved();
  }

  void _resetIfDayChanged() {
    final today = now().walkDate;
    if (_date == today) return;
    _date = today;
    _steps = null;
    _anchorSteps = null;
    _anchorCount = null;
    _hasHealthSteps = false;
    _emit();
  }

  void _syncIfAchieved() {
    final goal = _goal;
    final anchorSteps = _anchorSteps;
    final today = now().walkDate;
    if (_disposed ||
        goal == null ||
        goal <= 0 ||
        anchorSteps == null ||
        _date != today ||
        anchorSteps < goal ||
        _achievedSyncDate == today) {
      return;
    }
    _achievedSyncDate = today;
    _syncRequests.add(null);
  }

  @override
  Future<WalkSaveResult> sync({
    required String memberId,
    bool full = false,
    bool Function()? isCancelled,
    bool background = false,
  }) async {
    _resetIfDayChanged();
    final result = await _sync(
      memberId: memberId,
      full: full,
      isCancelled: isCancelled,
      background: background,
    );
    final steps = result.steps;
    if (result.date == now().walkDate && steps != null) {
      _anchor(steps);
    } else {
      _emit();
    }
    return result;
  }

  @override
  void applyServerSteps(int serverSteps, {required String date, int? goal}) {
    if (_disposed) return;
    final today = now().walkDate;
    if (goal != null) {
      _goal = goal;
      _syncIfAchieved();
    }
    if (date != today ||
        serverSteps < 0 ||
        (_date == today && _hasHealthSteps)) {
      return;
    }
    _date = date;
    _steps = serverSteps;
    _emit();
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
      final state = await _localDataSource.readState(memberId);
      Future<void> save() async {
        if (await active()) {
          await _localDataSource.saveState(memberId, state);
        }
      }

      if (!await _readAndSaveSteps(
        state: state,
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
        active: active,
        save: save,
      );
      if (await _tokenManager.memberId != memberId ||
          isCancelled?.call() == true ||
          !await _localDataSource.ownsLock('steps', owner)) {
        return const WalkSaveResult();
      }
      final resultDate = now().walkDate;
      return WalkSaveResult(
        date: resultDate,
        steps: (days[resultDate] as Map?)?['total'] as int?,
        uploaded: summary.uploaded,
        rewardChanged: summary.rewardChanged,
        unauthorized: summary.unauthorized,
      );
    } finally {
      await _localDataSource.releaseLock('steps', owner);
    }
  }

  Future<bool> _readAndSaveSteps({
    required Map<String, dynamic> state,
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
        .where(
          (date) =>
              full ||
              (reads[date] as int? ?? 0) <= now().millisecondsSinceEpoch,
        )
        .toList();
    state['days'] = days;
    state['reads'] = reads;

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
        day['total'] = total;
        days[date] = day;
      }
      await save();
    }
    days.removeWhere((date, _) => !date.isWalkDateAllowed(now()));
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

  Future<({int uploaded, bool rewardChanged, bool unauthorized})>
      _uploadAndSaveSteps({
    required Map<String, dynamic> days,
    required Future<bool> Function() active,
    required Future<void> Function() save,
  }) async {
    var uploaded = 0;
    var rewardChanged = false;
    var unauthorized = false;
    for (final date in days.keys.toList()..sort()) {
      if (!await active()) break;
      if (!date.isWalkDateAllowed(now())) {
        days.remove(date);
        await save();
        continue;
      }
      final day = days[date] as Map<String, dynamic>;
      final total = day['total'] as int;
      if (total == day['sent']) continue;
      final result = await _syncDay(date: date, steps: total);
      if (result.status == WalkSyncStatus.unauthorized) {
        unauthorized = true;
        break;
      }
      if (!await active()) break;
      if (result.status == WalkSyncStatus.success) {
        uploaded++;
        rewardChanged |= result.achieved && day['achieved'] != true;
        day['sent'] = total;
        if (result.achieved) day['achieved'] = true;
        await save();
      }
    }
    return (
      uploaded: uploaded,
      rewardChanged: rewardChanged,
      unauthorized: unauthorized,
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
