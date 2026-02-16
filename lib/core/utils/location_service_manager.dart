import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/model/location/location_service_state.dart';

class LocationServiceManager {
  LocationServiceManager._();

  static final _controller = StreamController<LocationServiceState>.broadcast();

  static Stream<LocationServiceState> get locationServiceState =>
      _controller.stream;

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
    _timer ??= Timer.periodic(interval, (_) async {
      final state = await _checkState();
      if (_currentState == null || _currentState != state) {
        _currentState = state;
        _controller.add(state);
      }
    });
  }

  static void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
    _currentState = null;
  }

  static Future<LocationServiceState> _checkState() async {
    final serviceEnabled = await Permission.location.serviceStatus.isEnabled;
    final permissionGranted = await checkLocationPermission();
    return LocationServiceState(
        serviceEnabled: serviceEnabled, permissionGranted: permissionGranted);
  }
}
