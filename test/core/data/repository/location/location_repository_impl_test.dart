import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/location/location_repository_impl.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/location/location_local_data_source.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source.dart';
import 'package:widyu/core/model/location/location_update_request.dart';
import 'package:widyu/core/model/location/user_location.dart';

void main() {
  late _LocalDataSource local;
  late _RemoteDataSource remote;
  late LocationRepositoryImpl repository;

  LocationRepositoryImpl build({
    int? memberId = 1023,
    int queueMax = 2,
    Duration keepaliveInterval = const Duration(seconds: 60),
  }) =>
      LocationRepositoryImpl(
        localDataSource: local,
        remoteDataSource: remote,
        authLocalDataSource: _FakeAuthLocalDataSource(memberId),
        deviceLocalDataSource: _FakeDeviceLocalDataSource('ph-test'),
        queueMax: queueMax,
        keepaliveInterval: keepaliveInterval,
      );

  setUp(() {
    local = _LocalDataSource();
    remote = _RemoteDataSource();
    repository = build();
  });

  tearDown(() {
    repository.stopLocationUpload();
    local.dispose();
    remote.dispose();
  });

  test('스트림 위치는 reason=move 로, seq 는 1부터 증가하며 ts_ms 는 잰 시각이다', () async {
    await repository.startLocationUpload();

    local.add(_location(measuredAt: 1000));
    local.add(_location(measuredAt: 2000));
    local.add(_location(measuredAt: 3000));
    await _settle();

    expect(remote.sent.map((request) => request.reason),
        everyElement(LocationReason.move));
    expect(remote.sent.map((request) => request.seq), [1, 2, 3]);
    expect(remote.sent.map((request) => request.tsMs), [1000, 2000, 3000]);
    expect(remote.sent.first.deviceId, 'ph-test');
    expect(remote.sent.first.memberId, 1023);
    expect(
        remote.sent.map((request) => request.sessionId).toSet(), hasLength(1));
  });

  test('정확도가 낮은 위치도 걸러내지 않고 보낸다', () async {
    await repository.startLocationUpload();

    local.add(_location(measuredAt: 1000, accuracyM: 5000));
    await _settle();

    expect(remote.sent.single.accuracyM, 5000);
  });

  testWidgets('60초 동안 위치가 오지 않으면 현재 위치를 받아 reason=keepalive 로 보낸다',
      (tester) async {
    local.currentLocation = _location(measuredAt: 7000);
    await repository.startLocationUpload();

    await tester.pump(const Duration(seconds: 60));
    // getCurrentLocation 과 memberId 조회가 끝나도록 마이크로태스크를 흘린다.
    await tester.pump();

    expect(local.currentLocationCalls, 1);
    expect(remote.sent.single.reason, LocationReason.keepalive);
    expect(remote.sent.single.tsMs, 7000);
    expect(remote.sent.single.seq, 1);
    // 다음 주기 타이머가 남아 있으면 widget 바인딩이 테스트를 실패시킨다.
    repository.stopLocationUpload();
  });

  testWidgets('현재 위치를 못 받으면 keepalive 를 건너뛰고 다음 주기를 기다린다', (tester) async {
    local.currentLocation = null;
    await repository.startLocationUpload();

    await tester.pump(const Duration(seconds: 60));
    await tester.pump();
    expect(remote.sent, isEmpty);

    local.currentLocation = _location(measuredAt: 9000);
    await tester.pump(const Duration(seconds: 60));
    await tester.pump();
    expect(remote.sent.single.reason, LocationReason.keepalive);
    repository.stopLocationUpload();
  });

  test('전송 실패는 대기열에 남고 연결이 복구되면 같은 seq 로 재전송한다', () async {
    remote.sendSucceeds = false;
    await repository.startLocationUpload();

    local.add(_location(measuredAt: 1000));
    local.add(_location(measuredAt: 2000));
    await _settle();
    expect(remote.sent.map((request) => request.seq), [1, 2]);

    remote.sendSucceeds = true;
    remote.connection.add(true);
    await _settle();

    final resent = remote.sent.skip(2).toList();
    expect(resent.map((request) => request.seq), [1, 2]);
    expect(resent.map((request) => request.tsMs), [1000, 2000]);

    // 성공한 요청은 큐에서 빠지므로 다시 연결돼도 재전송하지 않는다.
    remote.connection.add(true);
    await _settle();
    expect(remote.sent, hasLength(4));
  });

  test('대기열 상한을 넘으면 가장 오래된 요청부터 버린다', () async {
    remote.sendSucceeds = false;
    await repository.startLocationUpload();

    local.add(_location(measuredAt: 1000));
    local.add(_location(measuredAt: 2000));
    local.add(_location(measuredAt: 3000));
    await _settle();

    remote.sendSucceeds = true;
    remote.sent.clear();
    remote.connection.add(true);
    await _settle();

    expect(remote.sent.map((request) => request.seq), [2, 3]);
  });

  test('memberId 가 없으면 전송하지 않는다', () async {
    repository = build(memberId: null);
    await repository.startLocationUpload();

    local.add(_location(measuredAt: 1000));
    await _settle();

    expect(remote.sent, isEmpty);
  });

  test('중단하면 이후 위치는 전송하지 않는다', () async {
    await repository.startLocationUpload();
    repository.stopLocationUpload();

    local.add(_location(measuredAt: 1000));
    await _settle();

    expect(remote.sent, isEmpty);
  });
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

UserLocation _location({required int measuredAt, double accuracyM = 8.5}) =>
    UserLocation(
      latitude: 37.5551,
      longitude: 126.9707,
      measuredAt: measuredAt,
      accuracyM: accuracyM,
      speedMps: 0.9,
    );

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  _FakeAuthLocalDataSource(this.memberId);

  final int? memberId;

  @override
  Future<int?> getMemberId() async => memberId;

  @override
  Future<void> saveAuthentication(
    int memberId,
    String accessToken,
    String refreshToken,
  ) async {}

  @override
  Future<void> removeAuthentication() async {}
}

class _FakeDeviceLocalDataSource implements DeviceLocalDataSource {
  _FakeDeviceLocalDataSource(this.deviceId);

  final String deviceId;

  @override
  Future<String> getDeviceId() async => deviceId;
}

class _LocalDataSource implements LocationLocalDataSource {
  final _controller = StreamController<UserLocation>.broadcast();

  UserLocation? currentLocation;
  int currentLocationCalls = 0;

  void add(UserLocation location) => _controller.add(location);

  void dispose() => _controller.close();

  @override
  Stream<UserLocation> getLocation() => _controller.stream;

  @override
  Future<UserLocation?> getCurrentLocation() async {
    currentLocationCalls++;
    return currentLocation;
  }
}

class _RemoteDataSource implements LocationRemoteDataSource {
  final connection = StreamController<bool>.broadcast();
  final sent = <LocationUpdateRequest>[];

  bool sendSucceeds = true;

  void dispose() => connection.close();

  @override
  Stream<bool> get connectionState => connection.stream;

  @override
  bool sendLocation(LocationUpdateRequest request) {
    sent.add(request);
    return sendSucceeds;
  }
}
