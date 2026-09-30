import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/location/user_location.dart';

void main() {
  test('측정 시각·정확도·속도가 직렬화에 포함된다', () {
    const location = UserLocation(
      latitude: 37.5,
      longitude: 127.0,
      measuredAt: 1700000000000,
      accuracyM: 12.5,
      speedMps: 1.25,
    );

    expect(location.toJson(), containsPair('measuredAt', 1700000000000));
    expect(location.toJson(), containsPair('accuracyM', 12.5));
    expect(location.toJson(), containsPair('speedMps', 1.25));
  });
}
