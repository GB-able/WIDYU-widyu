import 'dart:async';

import 'package:widyu/background_service.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/location_service_manager.dart';

import 'package:flutter/foundation.dart';

typedef HasToken = Future<bool> Function();
typedef LocationStateReader = Future<LocationServiceState> Function();
typedef LocationMonitor = Future<void> Function();
typedef AutoStartSetter = Future<void> Function(bool value);
typedef BackgroundServiceAction = Future<void> Function();

/// 로그인 토큰과 위치 공유 준비 상태를 배경 서비스에 반영한다.
class AppServiceController extends ChangeNotifier {
  AppServiceController({
    HasToken? hasToken,
    LocationStateReader? refreshLocationState,
    Stream<LocationServiceState>? locationStates,
    LocationMonitor? startMonitoring,
    LocationMonitor? stopMonitoring,
    AutoStartSetter? setAutoStart,
    BackgroundServiceAction? startBackground,
    BackgroundServiceAction? stopBackground,
  })  : _hasToken = hasToken ?? TokenManager().hasToken,
        _refreshLocationState =
            refreshLocationState ?? LocationServiceManager.refresh,
        _locationStates =
            locationStates ?? LocationServiceManager.locationServiceState,
        _startMonitoring = startMonitoring ?? _startDefaultMonitoring,
        _stopMonitoring = stopMonitoring ?? _stopDefaultMonitoring,
        _setAutoStart = setAutoStart ?? setAutoStartOnBoot,
        _startBackground = startBackground ?? startBackgroundService,
        _stopBackground = stopBackground ?? stopBackgroundService;

  static Future<void> _startDefaultMonitoring() async =>
      LocationServiceManager.startMonitoring();
  static Future<void> _stopDefaultMonitoring() async =>
      LocationServiceManager.stopMonitoring();

  final HasToken _hasToken;
  final LocationStateReader _refreshLocationState;
  final Stream<LocationServiceState> _locationStates;
  final LocationMonitor _startMonitoring;
  final LocationMonitor _stopMonitoring;
  final AutoStartSetter _setAutoStart;
  final BackgroundServiceAction _startBackground;
  final BackgroundServiceAction _stopBackground;

  StreamSubscription<LocationServiceState>? _locationSubscription;
  Future<void> _queue = Future.value();
  LocationServiceState? _state;
  bool _started = false;
  bool _disposed = false;
  int _generation = 0;
  bool? _autoStartEnabled;
  bool _hasServiceError = false;

  LocationServiceState? get state => _state;

  Future<void> start() {
    if (_disposed) return Future.value();
    if (_started) return refresh();
    _started = true;
    final generation = ++_generation;
    return _enqueue(() async {
      if (!_isActive(generation)) return;
      final hasToken = await _hasToken();
      if (!_isActive(generation)) return;
      if (!hasToken) {
        _started = false;
        await _reconcile(null, tokenAvailable: false, generation: generation);
        return;
      }
      if (!_isActive(generation)) return;
      _locationSubscription ??= _locationStates.listen(
        (next) => unawaited(_enqueue(() => _onLocationState(next, generation))),
      );
      await _startMonitoring();
      await _refresh(generation);
    });
  }

  Future<void> stop() {
    _started = false;
    ++_generation;
    return _enqueue(() async {
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      await _stopMonitoring();
      await _reconcile(null, tokenAvailable: false, generation: _generation);
    });
  }

  Future<void> refresh() {
    // background isolate가 자체 종료하면서 native auto-start 설정을 바꿀 수 있다.
    // 명시적 refresh(앱 복귀)에서는 그 값을 다시 적용한다.
    _autoStartEnabled = null;
    final generation = _generation;
    return _enqueue(() => _refresh(generation));
  }

  Future<void> _refresh(int generation) async {
    final tokenAvailable = await _hasToken();
    if (!_isCurrent(generation)) return;
    final next = await _refreshLocationState();
    if (!_isCurrent(generation)) return;
    await _reconcile(
      next,
      tokenAvailable: tokenAvailable && _started,
      generation: generation,
    );
  }

  Future<void> _onLocationState(
    LocationServiceState next,
    int generation,
  ) async {
    if (!_isCurrent(generation)) return;
    await _reconcile(
      next,
      tokenAvailable: await _hasToken(),
      generation: generation,
    );
  }

  Future<void> _reconcile(
    LocationServiceState? next, {
    required bool tokenAvailable,
    required int generation,
  }) async {
    if (!_isCurrent(generation)) return;
    if (_state != next) {
      _state = next;
      notifyListeners();
    }
    final canRun = tokenAvailable && next?.isAvailable == true;
    var failed = false;
    try {
      if (_autoStartEnabled != canRun || _hasServiceError) {
        await _setAutoStart(canRun);
        _autoStartEnabled = canRun;
      }
    } catch (error, stack) {
      debugPrint('[AppServiceController] 서비스 상태 반영 실패: $error\n$stack');
      failed = true;
    }
    if (!_isCurrent(generation)) return;
    try {
      if (canRun) {
        await _startBackground();
      } else {
        await _stopBackground();
      }
    } catch (error, stack) {
      debugPrint('[AppServiceController] 서비스 상태 반영 실패: $error\n$stack');
      failed = true;
    }
    _setServiceError(failed);
  }

  void _setServiceError(bool value) {
    if (_hasServiceError == value) return;
    _hasServiceError = value;
    if (!_disposed) notifyListeners();
  }

  bool _isActive(int generation) =>
      !_disposed && _started && generation == _generation;
  bool _isCurrent(int generation) => !_disposed && generation == _generation;

  Future<void> _enqueue(Future<void> Function() operation) {
    final next = _queue.then((_) => operation(), onError: (_) => operation());
    _queue = next.catchError((error, stack) {
      debugPrint('[AppServiceController] 작업 실패: $error\n$stack');
    });
    return _queue;
  }

  @override
  void dispose() {
    _disposed = true;
    _started = false;
    ++_generation;
    unawaited(_enqueue(() async {
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      await _stopMonitoring();
      try {
        if (_autoStartEnabled != false) await _setAutoStart(false);
        _autoStartEnabled = false;
      } catch (error, stack) {
        debugPrint('[AppServiceController] 자동 시작 해제 실패: $error\n$stack');
      }
      try {
        await _stopBackground();
      } catch (error, stack) {
        debugPrint('[AppServiceController] 서비스 종료 실패: $error\n$stack');
      }
    }));
    super.dispose();
  }
}
