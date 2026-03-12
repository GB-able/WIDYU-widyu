import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/data/datasources/location/location_local_data_source.dart';
import 'package:widyu/core/model/location/user_location.dart';

class LocationLocalDataSourceImpl extends LocationLocalDataSource {
  static final LocationLocalDataSourceImpl _instance =
      LocationLocalDataSourceImpl._internal();

  factory LocationLocalDataSourceImpl() => _instance;

  LocationLocalDataSourceImpl._internal();

  @override
  Stream<UserLocation> getLocation() {
    final locationSetting = Platform.isIOS
        ? AppleSettings(
            accuracy: LocationAccuracy.best,
            activityType: ActivityType.fitness,
            distanceFilter: 1,
            pauseLocationUpdatesAutomatically: true,
            showBackgroundLocationIndicator: true,
            allowBackgroundLocationUpdates: true,
          )
        : AndroidSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 1,
            forceLocationManager: false,
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
