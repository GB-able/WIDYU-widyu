import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/data/source/location/location_local_data_source_impl.dart';

Position _position({
  required bool hasSpeed,
  required bool hasSpeedAccuracy,
  required bool hasHeading,
  double speed = 0,
  double speedAccuracy = 0,
  double heading = 0,
}) =>
    Position(
      latitude: 37.5,
      longitude: 127.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(1700000000000),
      accuracy: 24.0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: heading,
      headingAccuracy: 0,
      speed: speed,
      speedAccuracy: speedAccuracy,
      hasAccuracy: true,
      hasSpeed: hasSpeed,
      hasSpeedAccuracy: hasSpeedAccuracy,
      hasHeading: hasHeading,
    );

void main() {
  test('위성 없이 잡힌 위치(속도·방향 없음)는 0 대신 null 로 옮긴다', () {
    final location = LocationLocalDataSourceImpl.toUserLocation(
      _position(hasSpeed: false, hasSpeedAccuracy: false, hasHeading: false),
    );

    expect(location.speedMps, isNull);
    expect(location.speedAccuracyMps, isNull);
    expect(location.headingDeg, isNull);
    expect(location.accuracyM, 24.0);
  });

  test('실제로 잰 속도 0 은 0 으로 남긴다', () {
    final location = LocationLocalDataSourceImpl.toUserLocation(
      _position(hasSpeed: true, hasSpeedAccuracy: true, hasHeading: true),
    );

    expect(location.speedMps, 0.0);
    expect(location.speedAccuracyMps, 0.0);
    expect(location.headingDeg, 0.0);
  });

  test('잰 속도·방향은 그대로 옮긴다', () {
    final location = LocationLocalDataSourceImpl.toUserLocation(
      _position(
        hasSpeed: true,
        hasSpeedAccuracy: true,
        hasHeading: true,
        speed: 11.3,
        speedAccuracy: 0.8,
        heading: 212.0,
      ),
    );

    expect(location.speedMps, 11.3);
    expect(location.speedAccuracyMps, 0.8);
    expect(location.headingDeg, 212.0);
  });
}
