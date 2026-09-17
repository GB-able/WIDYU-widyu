import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/data/source/location/location_local_data_source.dart';
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

  @override
  Future<UserLocation?> getCurrentLocation() async {
    // 길찾기는 출발지 없이도 열 수 있으므로 여기서의 실패는 치명적이지 않다.
    // 어떤 단계에서 막히든 예외를 밖으로 던지지 않고 null 로만 알린다.
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // GPS 가 잡히지 않는 실내 등에서 무한정 기다리지 않도록 timeLimit 을 둔다.
      // 시간이 초과되면 TimeoutException 이 발생해 아래 catch 로 떨어진다.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      log('현재 위치 조회 실패: $e');
      return null;
    }
  }
}
