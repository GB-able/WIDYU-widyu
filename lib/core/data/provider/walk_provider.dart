import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';
import 'package:widyu/walk_background_service.dart';

class WalkProvider with ChangeNotifier, WidgetsBindingObserver {
  WalkProvider({
    required WalkRepository repository,
  }) : _repository = repository;

  final WalkRepository _repository;
  Timer? _timer;
  Future<void>? _starting;
  Future<void>? _refreshing;
  String? _memberId;
  String? _date;
  int? _steps;
  bool _hasHealthSteps = false;
  bool _disposed = false;
  bool _observing = false;
  bool _tracking = false;

  String get today => DateTime.now().walkDate;
  int get steps => _date == today ? _steps ?? 0 : 0;
  bool get hasTodaySteps => _date == today && _steps != null;
  bool get isTracking => !_disposed && _tracking;

  Future<void> start() {
    if (_disposed || _tracking) return Future.value();
    return _starting ??= _start().whenComplete(() => _starting = null);
  }

  Future<void> _start() async {
    try {
      if (!await TokenManager().hasToken()) return;
      _memberId = await TokenManager().memberId;
      if (_disposed || _memberId == null) return;
      if (!_observing) {
        WidgetsBinding.instance.addObserver(this);
        _observing = true;
      }
      final permitted = await _repository.ensurePermission();
      if (_disposed) return;
      _tracking = permitted;
      if (permitted) {
        try {
          await startWalkBackgroundService();
        } catch (error, stack) {
          WiduLog.data.w('걸음수 백그라운드 등록 보류', error: error, stackTrace: stack);
        }
        if (_disposed) return;
      }
      _startTimer();
      await refresh(full: true);
    } catch (error, stack) {
      WiduLog.data.w('걸음수 연동 시작 실패', error: error, stackTrace: stack);
    }
    if (!_disposed) notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_disposed || _memberId == null) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(refresh()),
    );
  }

  Future<void> refresh({bool full = false}) {
    if (_disposed || _memberId == null) return Future.value();
    return _refreshing ??= _refresh(
      full: full,
    ).whenComplete(() => _refreshing = null);
  }

  Future<void> _refresh({required bool full}) async {
    if (_date != today) {
      _date = today;
      _steps = null;
      _hasHealthSteps = false;
      notifyListeners();
    }
    try {
      final result = await _repository.sync(
        memberId: _memberId!,
        full: full,
        isCancelled: () => _disposed,
      );
      if (_disposed) return;
      if (result.unauthorized) {
        WiduLog.data.w('인증 만료로 걸음수 동기화 중단');
        _timer?.cancel();
        _tracking = false;
        _memberId = null;
        await stopWalkBackgroundService();
        if (_disposed) return;
      } else {
        // 걸음 수는 건강값이라 남기지 않는다(docs/logging-strategy.md §6.1).
        WiduLog.data.d('걸음수 동기화 완료 uploaded=${result.uploaded}');
      }
      if (result.date == today && result.steps != null) {
        _date = result.date;
        _steps = result.steps;
        _hasHealthSteps = true;
      }
      notifyListeners();
    } catch (error, stack) {
      WiduLog.data.w('걸음수 동기화 보류', error: error, stackTrace: stack);
    }
  }

  void applyServerSteps(int serverSteps, {required String date}) {
    if (_disposed ||
        date != today ||
        serverSteps < 0 ||
        (_date == today && _hasHealthSteps)) {
      return;
    }
    _date = date;
    _steps = serverSteps;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _tracking = false;
    _timer?.cancel();
    if (_observing) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
