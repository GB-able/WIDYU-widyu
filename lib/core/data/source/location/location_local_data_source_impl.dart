import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/data/source/location/location_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
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
            activityType: ActivityType.fitness,
            distanceFilter: 1,
            pauseLocationUpdatesAutomatically: true,
            showBackgroundLocationIndicator: true,
          )
        : AndroidSettings(
            distanceFilter: 1,
            intervalDuration: const Duration(seconds: 5),
          );
    return Geolocator.getPositionStream(locationSettings: locationSetting)
        .map((position) {
      return toUserLocation(position);
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

      return toUserLocation(position);
    } catch (e, stack) {
      WiduLog.data.w('현재 위치 조회 실패', error: e, stackTrace: stack);
      return null;
    }
  }

  /// 플랫폼이 재지 못한 속도·속도 정확도·방향은 0 이 아니라 null 로 둔다.
  /// 지하 역 와이파이처럼 위성 없이 잡힌 위치는 이 값들이 없는데, 0 으로 보내면
  /// 서버에서 「멈춤」과 구별되지 않는다.
  @visibleForTesting
  static UserLocation toUserLocation(Position position) => UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        measuredAt: position.timestamp.millisecondsSinceEpoch,
        accuracyM: position.accuracy,
        speedMps: position.hasSpeed ? position.speed : null,
        speedAccuracyMps:
            position.hasSpeedAccuracy ? position.speedAccuracy : null,
        headingDeg: position.hasHeading ? position.heading : null,
        altitudeM: position.altitude,
        isMock: position.isMocked,
      );
}
