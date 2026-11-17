import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/device/device_event_repository_impl.dart';
import 'package:widyu/core/data/source/device/device_event_remote_data_source.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_status_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

void main() {
  // 저장소 기본 주기와 같다.
  const interval = Duration(minutes: 1);
  late _LocalDataSource local;
  late _RemoteDataSource remote;
  late _StatusDataSource status;
  late StreamController<SensorConfig> configs;
  late StreamController<LocationServiceState> locations;
  late DeviceEventRepositoryImpl repository;

  setUp(() {
    local = _LocalDataSource();
    remote = _RemoteDataSource();
    status = _StatusDataSource();
    configs = StreamController<SensorConfig>.broadcast(sync: true);
    locations = StreamController<LocationServiceState>.broadcast(sync: true);
    repository = DeviceEventRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
      configs: configs.stream,
      deviceLocalDataSource: _DeviceDataSource(),
      deviceStatusLocalDataSource: status,
      locationStates: () => locations.stream,
    );
  });

  tearDown(() {
    configs.close();
    locations.close();
    status.dispose();
  });

  LocationServiceState location(
          {bool service = true, bool permission = true}) =>
      LocationServiceState(
          serviceEnabled: service, permissionGranted: permission);

  /// 연구 모드로 시작하고 네트워크·위치 기준값(wifi, 사용 가능)을 흘린다.
  void startResearch(FakeAsync async) {
    repository.start();
    configs.add(const SensorConfig(collectionMode: 'research'));
    status.network.add('wifi');
    locations.add(location());
    async.flushMicrotasks();
  }

  test('항목별 결과가 무엇이든 받은 이벤트는 워치에서 지우고 다시 보내지 않는다', () {
    fakeAsync((async) {
      remote.results = ['STORED', 'DUPLICATE', 'REJECTED'];
      repository.start();
      local.addEvents(['e1', 'e2', 'e3']);

      async.elapse(interval);
      async.elapse(interval);

      expect(remote.sentIds, [
        ['e1', 'e2', 'e3'],
      ]);
      expect(local.consumed, ['e1', 'e2', 'e3']);
      repository.stop();
    });
  });

  test('네트워크 오류·5xx 면 남겨 두었다가 다음 주기에 같은 묶음을 다시 보낸다', () {
    fakeAsync((async) {
      remote.results = null;
      repository.start();
      local.addEvents(['e1', 'e2']);

      async.elapse(interval);
      remote.results = ['STORED', 'DUPLICATE'];
      async.elapse(interval);

      expect(remote.sentIds, [
        ['e1', 'e2'],
        ['e1', 'e2'],
      ]);
      expect(local.consumed, ['e1', 'e2']);
      repository.stop();
    });
  });

  test('같은 event_id 가 다시 흘러와도 한 번만 보낸다', () {
    fakeAsync((async) {
      remote.results = ['STORED'];
      repository.start();
      local.addEvents(['e1', 'e1']);

      async.elapse(interval);

      expect(remote.sentIds, [
        ['e1'],
      ]);
      repository.stop();
    });
  });

  test('500개가 쌓이면 주기를 기다리지 않고 500개씩 나눠 보낸다', () {
    fakeAsync((async) {
      remote.results = List.filled(500, 'STORED');
      repository.start();
      local.addEvents([for (var i = 0; i < 501; i++) 'e$i']);

      async.flushMicrotasks();
      expect(remote.sentIds.map((ids) => ids.length), [500]);

      remote.results = ['STORED'];
      async.elapse(interval);
      expect(remote.sentIds.map((ids) => ids.length), [500, 1]);
      expect(local.consumed, hasLength(501));
      repository.stop();
    });
  });

  test('출시 모드에서는 네트워크·위치가 바뀌어도 폰 이벤트를 만들지 않는다', () {
    fakeAsync((async) {
      remote.results = [];
      repository.start();
      configs.add(const SensorConfig());
      status.network
        ..add('wifi')
        ..add('none');
      locations
        ..add(location())
        ..add(location(service: false));

      async.elapse(interval);

      expect(remote.sentIds, isEmpty);
      repository.stop();
    });
  });

  test('연구 모드는 기준값을 버리고 바뀐 네트워크 종류만 남긴다', () {
    fakeAsync((async) {
      remote.results = ['STORED'];
      startResearch(async);

      status.network
        ..add('wifi')
        ..add('none');
      async.elapse(interval);

      expect(remote.sentEvents.single, containsPair('kind', 'NETWORK_CHANGED'));
      expect(remote.sentEvents.single, containsPair('source', 'phone'));
      expect(remote.sentEvents.single, containsPair('device_id', 'ph-test'));
      expect(remote.sentEvents.single['attributes'], {'type': 'none'});
      repository.stop();
    });
  });

  test('위치를 못 쓰게 되면 사유와 함께 STOPPED, 다시 쓸 수 있으면 RESTARTED 를 남긴다', () {
    fakeAsync((async) {
      remote.results = ['STORED', 'STORED', 'STORED'];
      startResearch(async);

      locations
        ..add(location(service: false))
        ..add(location())
        ..add(location(permission: false));
      async.elapse(interval);

      expect(remote.sentEvents.map((e) => e['kind']), [
        'LOCATION_STOPPED',
        'LOCATION_RESTARTED',
        'LOCATION_STOPPED',
      ]);
      expect(remote.sentEvents.map((e) => e['attributes']), [
        {'reason': 'service_disabled'},
        {'reason': 'available'},
        {'reason': 'permission_denied'},
      ]);
      repository.stop();
    });
  });

  test('폰 이벤트는 서버가 받은 뒤 워치 Data Layer 에서 지우지 않는다', () {
    fakeAsync((async) {
      remote.results = ['STORED', 'STORED'];
      startResearch(async);

      local.addEvents(['w1']);
      status.network.add('mobile');
      async.elapse(interval);

      expect(remote.sentEvents, hasLength(2));
      expect(local.consumed, ['w1']);
      repository.stop();
    });
  });

  test('연구 모드에서 벗어나면 폰 상태 감시를 멈춘다', () {
    fakeAsync((async) {
      remote.results = [];
      startResearch(async);

      configs.add(const SensorConfig());
      status.network.add('none');
      async.elapse(interval);

      expect(remote.sentIds, isEmpty);
      repository.stop();
    });
  });
}

class _StatusDataSource implements DeviceStatusLocalDataSource {
  final network = StreamController<String>.broadcast(sync: true);

  void dispose() => network.close();

  @override
  Stream<String> networkType() => network.stream;

  @override
  Future<Map<String, dynamic>> phoneStatus() async => {};

  @override
  Future<String> appVersion() async => '1.0.0';

  @override
  Future<String> locationPermission() async => 'always';

  @override
  Future<bool> watchConnected() async => true;
}

class _DeviceDataSource implements DeviceLocalDataSource {
  @override
  Future<String> getDeviceId() async => 'ph-test';
}

class _LocalDataSource implements SensorBatchLocalDataSource {
  final _controller = StreamController<SensorMessage>.broadcast(sync: true);
  final consumed = <String>[];

  void addEvents(List<String> ids) {
    for (final id in ids) {
      _controller.add(SensorMessage.deviceEvent({
        'event_id': id,
        'device_id': 'gw-test',
        'source': 'watch',
        'kind': 'SCREEN_ON',
        'occurred_at_ms': 1,
      }));
    }
  }

  @override
  Stream<SensorMessage> getSensorBatches() => _controller.stream;

  @override
  void consume({
    required String stream,
    required String sessionId,
    required int seq,
  }) {}

  @override
  void consumeEvent(String eventId) => consumed.add(eventId);
}

class _RemoteDataSource implements DeviceEventRemoteDataSource {
  List<String>? results;
  final sentIds = <List<String>>[];
  final sentEvents = <Map<String, dynamic>>[];

  @override
  Future<List<String>?> send(List<Map<String, dynamic>> events) async {
    sentIds.add([for (final event in events) event['event_id'] as String]);
    sentEvents.addAll(events);
    return results;
  }
}
