import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/location/user_location.dart';

void main() {
  test('측정 시각과 센서 부가 정보가 직렬화에 포함된다', () {
    const location = UserLocation(
      latitude: 37.5,
      longitude: 127.0,
      measuredAt: 1700000000000,
      accuracyM: 12.5,
      speedMps: 1.25,
      speedAccuracyMps: 0.5,
      headingDeg: 212.0,
      altitudeM: 41.2,
      isMock: true,
    );

    expect(
      location.toJson(),
      allOf(
        containsPair('measuredAt', 1700000000000),
        containsPair('accuracyM', 12.5),
        containsPair('speedMps', 1.25),
        containsPair('speedAccuracyMps', 0.5),
        containsPair('headingDeg', 212.0),
        containsPair('altitudeM', 41.2),
        containsPair('isMock', true),
      ),
    );
  });

  test('좌표만으로 만들면 나머지는 비고 isMock 은 false 다', () {
    const location = UserLocation(latitude: 36, longitude: 126);

    expect(location.measuredAt, isNull);
    expect(location.accuracyM, isNull);
    expect(location.isMock, isFalse);
  });
}
