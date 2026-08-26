import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/model/location/location_service_state.dart';

class LocationServiceManager {
  LocationServiceManager._();

  static final _controller = StreamController<LocationServiceState>.broadcast();

  /// 상태가 '변할 때'만 흘리는 스트림이기 때문에 구독 시점이 늦으면 다음 변화까지 아무것도 받지 못한다.
  /// 구독 시점의 마지막 상태를 한 번 먼저 흘려준다.
  static Stream<LocationServiceState> get locationServiceState async* {
    final cached = _currentState;
    if (cached != null) yield cached;
    yield* _controller.stream;
  }

  static Timer? _timer;
  static LocationServiceState? _currentState;

  static Future<void> requestLocationPermission() async {
    if (await checkLocationPermission()) return;

    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }
  }

  static Future<bool> checkLocationPermission() async {
    return await Permission.locationAlways.isGranted;
  }

  static void startMonitoring(
      {Duration interval = const Duration(seconds: 3)}) {
    if (_timer != null) return;
    // 첫 확인은 interval 을 기다리지 않는다.
    _emitState();
    _timer = Timer.periodic(interval, (_) => _emitState());
  }

  static void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _currentState = null;
  }

  static Future<void> _emitState() async {
    final state = await _checkState();
    if (_currentState == null || _currentState != state) {
      _currentState = state;
      _controller.add(state);
    }
  }

  static Future<LocationServiceState> _checkState() async {
    final serviceEnabled = await Permission.location.serviceStatus.isEnabled;
    final permissionGranted = await checkLocationPermission();
    return LocationServiceState(
        serviceEnabled: serviceEnabled, permissionGranted: permissionGranted);
  }
}
