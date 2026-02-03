import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/data/datasources/location/location_local_data_source.dart';

import '../../models/location/user_location.dart';

class LocationLocalDataSourceImpl extends LocationLocalDataSource {
  @override
  Stream<UserLocation> getLocation() {
    final locationSetting = Platform.isIOS
        ? AppleSettings(
            accuracy: LocationAccuracy.high,
            activityType: ActivityType.fitness,
            distanceFilter: 1,
            pauseLocationUpdatesAutomatically: true,
            showBackgroundLocationIndicator: true,
            allowBackgroundLocationUpdates: true,
          )
        : AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1,
            forceLocationManager: false,
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: '알림',
              notificationText: '위듀에서 사용자의 위치를 추적중입니다',
              enableWakeLock: true,
            ),
            intervalDuration: const Duration(seconds: 5),
          );
    return Geolocator.getPositionStream(locationSettings: locationSetting)
        .map((position) {
      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }
}
