import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/location/location_update_request.dart';

void main() {
  const request = LocationUpdateRequest(
    memberId: 1023,
    deviceId: 'ph-9c1',
    sessionId: 's-abc',
    seq: 5120,
    tsMs: 1760000000123,
    reason: LocationReason.move,
    lat: 37.5551,
    lon: 126.9707,
    isMock: false,
    accuracyM: 8.5,
    speedMps: 0.9,
    speedAccuracyMps: 0.5,
    headingDeg: 212.0,
    altitudeM: 41.2,
  );

  test('v2 키는 memberId 만 camelCase 이고 나머지는 snake_case 다', () {
    expect(request.toJson(), {
      'v': 2,
      'memberId': 1023,
      'device_id': 'ph-9c1',
      'session_id': 's-abc',
      'seq': 5120,
      'ts_ms': 1760000000123,
      'reason': 'move',
      'lat': 37.5551,
      'lon': 126.9707,
      'is_mock': false,
      'accuracy_m': 8.5,
      'speed_mps': 0.9,
      'speed_accuracy_mps': 0.5,
      'heading_deg': 212.0,
      'altitude_m': 41.2,
    });
  });

  test('is_mock 은 false 여도 키가 남는다', () {
    expect(request.toJson().containsKey('is_mock'), isTrue);
    expect(request.toJson()['is_mock'], isFalse);
  });

  test('회차 필드는 보내지 않는다 - 서버가 ts_ms 시점의 회차를 붙인다', () {
    expect(
      request.toJson().keys,
      isNot(anyElement(isIn(['run_id', 'study_id', 'participation_id']))),
    );
  });

  test('기존 v1 좌표·시각 키는 v2 요청에 들어가지 않는다', () {
    expect(
      request.toJson().keys,
      isNot(anyElement(isIn(['latitude', 'longitude', 'timestamp']))),
    );
  });

  test('reason 은 스펙이 허용한 3종뿐이다', () {
    expect(
      [LocationReason.move, LocationReason.keepalive, LocationReason.incident],
      ['move', 'keepalive', 'incident'],
    );
  });
}
