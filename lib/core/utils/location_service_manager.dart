import 'dart:async';

import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/utils/permission_manager.dart';

class LocationServiceManager {
  LocationServiceManager._();

  static final _controller = StreamController<LocationServiceState>.broadcast();
  static Timer? _timer;
  static LocationServiceState? _currentState;
  static Future<LocationServiceState>? _refreshing;
  static int? _refreshGeneration;
  static int _generation = 0;

  /// 상태가 '변할 때'만 흘리는 스트림이기 때문에 구독 시점이 늦으면 다음 변화까지 아무것도 받지 못한다.
  /// 구독 시점의 마지막 상태를 한 번 먼저 흘려준다.
  static Stream<LocationServiceState> get locationServiceState async* {
    final cached = _currentState;
    if (cached != null) yield cached;
    yield* _controller.stream;
  }

  /// 백그라운드 위치 업로드가 가능한 상태인지 여부.
  /// 위치 '항상 허용'(ACCESS_BACKGROUND_LOCATION) 을 기준으로 한다.
  static Future<bool> checkLocationPermission() =>
      PermissionManager.isBackgroundLocationGranted();

  /// 항상 허용 위치 권한과 GPS 상태를 새로 확인하고, 최신 세대일 때만 발행한다.
  static Future<LocationServiceState> refresh() {
    final refreshing = _refreshing;
    if (refreshing != null && _refreshGeneration == _generation) {
      return refreshing;
    }

    final generation = _generation;
    late final Future<LocationServiceState> future;
    future = _checkState().then((state) {
      if (generation == _generation) _publish(state);
      return state;
    }).whenComplete(() {
      if (identical(_refreshing, future)) {
        _refreshing = null;
        _refreshGeneration = null;
      }
    });
    _refreshing = future;
    _refreshGeneration = generation;
    return future;
  }

  static void startMonitoring(
      {Duration interval = const Duration(seconds: 3)}) {
    if (_timer != null) return;
    // 첫 확인은 interval 을 기다리지 않는다.
    unawaited(refresh());
    _timer = Timer.periodic(interval, (_) => unawaited(refresh()));
  }

  static void stopMonitoring() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    _currentState = null;
    _refreshing = null;
    _refreshGeneration = null;
  }

  static void _publish(LocationServiceState state) {
    if (_currentState == null || _currentState != state) {
      _currentState = state;
      _controller.add(state);
    }
  }

  static Future<LocationServiceState> _checkState() async {
    final serviceEnabled = await PermissionManager.isLocationServiceEnabled();
    final permissionGranted = await checkLocationPermission();
    return LocationServiceState(
        serviceEnabled: serviceEnabled, permissionGranted: permissionGranted);
  }
}
