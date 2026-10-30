import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/walk_background_service.dart';

/// 로그인 세션 동안 걸음 수를 읽고 서버와 동기화한다.
/// 앱이 보이는 동안 1분마다 건강값을 다시 읽고 센서 스트림으로 실시간 반영한다.
class WalkTracker with WidgetsBindingObserver {
  WalkTracker({
    required WalkRepository repository,
  }) : _repository = repository;

  final WalkRepository _repository;
  Timer? _timer;
  StreamSubscription<int>? _live;
  StreamSubscription<void>? _syncRequests;
  Future<void>? _starting;
  Future<void>? _syncing;
  bool _syncQueued = false;
  String? _memberId;
  bool _disposed = false;
  bool _observing = false;
  bool _tracking = false;

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
      _syncRequests ??=
          _repository.syncRequests.listen((_) => unawaited(sync()));
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
      _resume();
      await refresh();
      unawaited(sync());
    } catch (error, stack) {
      WiduLog.data.w('걸음수 연동 시작 실패', error: error, stackTrace: stack);
    }
  }

  void _resume() {
    _pause();
    if (_disposed || _memberId == null || !_tracking) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle != null && lifecycle != AppLifecycleState.resumed) return;
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(refresh()),
    );
    _live = _repository.liveStepCounts.listen(
      _repository.applyLiveCount,
      onError: (Object error) =>
          WiduLog.data.w('실시간 걸음수 스트림 보류', error: error),
    );
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    unawaited(_live?.cancel());
    _live = null;
  }

  Future<void> refresh() async {
    if (_disposed || !_tracking) return;
    try {
      await _repository.refreshTodaySteps();
    } catch (error, stack) {
      WiduLog.data.w('걸음수 읽기 보류', error: error, stackTrace: stack);
    }
  }

  Future<void> sync() {
    if (_disposed || _memberId == null) return Future.value();
    if (_syncing case final syncing?) {
      _syncQueued = true;
      return syncing;
    }
    return _syncing = _sync().whenComplete(() {
      _syncing = null;
      if (!_syncQueued) return;
      _syncQueued = false;
      unawaited(sync());
    });
  }

  Future<void> _sync() async {
    try {
      final result = await _repository.sync(
        memberId: _memberId!,
        full: true,
        isCancelled: () => _disposed,
      );
      if (_disposed) return;
      if (!result.unauthorized) {
        // 걸음 수는 건강값이라 남기지 않는다(docs/logging-strategy.md §6.1).
        WiduLog.data.d('걸음수 동기화 완료 uploaded=${result.uploaded}');
        return;
      }
      WiduLog.data.w('인증 만료로 걸음수 동기화 중단');
      _pause();
      _tracking = false;
      _memberId = null;
      await stopWalkBackgroundService();
    } catch (error, stack) {
      WiduLog.data.w('걸음수 동기화 보류', error: error, stackTrace: stack);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.resumed) {
      _resume();
      unawaited(refresh());
      unawaited(sync());
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _pause();
      unawaited(sync());
    }
  }

  void dispose() {
    _disposed = true;
    _tracking = false;
    _pause();
    unawaited(_syncRequests?.cancel());
    _syncRequests = null;
    if (_observing) WidgetsBinding.instance.removeObserver(this);
  }
}
