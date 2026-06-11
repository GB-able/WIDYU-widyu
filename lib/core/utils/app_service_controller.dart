import 'dart:async';

import 'package:widyu/background_service.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/extensions/location_service_state_extension.dart';
import 'package:widyu/core/utils/location_service_manager.dart';
import 'package:widyu/core/utils/show_toast.dart';

class AppServiceController {
  final TokenManager _tokenManager;

  AppServiceController({required TokenManager tokenManager})
      : _tokenManager = tokenManager;

  StreamSubscription<LocationServiceState>? _locationSubscription;

  Future<void> start() async {
    if (_locationSubscription != null) return;
    if (!await _tokenManager.hasToken()) return;

    LocationServiceManager.startMonitoring();
    _locationSubscription =
        LocationServiceManager.locationServiceState.listen((state) async {
      final message = state.message;
      if (message != null) {
        showToast(message);
        await stopBackgroundService();
        return;
      }
      await startBackgroundService();
    });
  }

  Future<void> stop() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    LocationServiceManager.stopMonitoring();
    await stopBackgroundService();
  }
}
