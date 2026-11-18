import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/device/heartbeat_repository_impl.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_status_local_data_source.dart';
import 'package:widyu/core/data/source/device/heartbeat_remote_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

void main() {
  // 저장소 기본 주기와 같다.
  const interval = Duration(minutes: 5);
  late StreamController<SensorConfig> configs;
  late _SensorLocal sensorLocal;
  late _Status status;
  late _Remote remote;
  late HeartbeatRepositoryImpl repository;

  setUp(() {
    configs = StreamController<SensorConfig>.broadcast(sync: true);
    sensorLocal = _SensorLocal();
    status = _Status();
    remote = _Remote();
    repository = HeartbeatRepositoryImpl(
      configs: configs.stream,
      sensorBatchLocalDataSource: sensorLocal,
      deviceLocalDataSource: _Device(),
      deviceStatusLocalDataSource: status,
      remoteDataSource: remote,
      socketConnected: () => true,
      queueDepth: () => 3,
    );
  });

  tearDown(() => configs.close());

  test('연구 모드인 동안만 바로 한 번, 이후 주기마다 보낸다', () {
    fakeAsync((async) {
      repository.start();
      configs.add(const SensorConfig());
      async.elapse(interval);
      expect(remote.sent, isEmpty);

      configs.add(const SensorConfig(collectionMode: 'research'));
      async.flushMicrotasks();
      async.elapse(interval);
      expect(remote.sent, hasLength(2));

      configs.add(const SensorConfig());
      async.elapse(interval * 2);
      expect(remote.sent, hasLength(2));
      repository.stop();
    });
  });

  test('워치가 연결되지 않았으면 watch 에 connected 만 싣는다', () {
    fakeAsync((async) {
      status.connected = false;
      repository.start();
      configs.add(const SensorConfig(collectionMode: 'research'));
      async.flushMicrotasks();

      final heartbeat = remote.sent.single;
      expect(heartbeat['watch'], {'connected': false});
      expect(heartbeat['phone'], {
        'battery_pct': 71,
        'charging': false,
        'app_ver': '1.4.2',
        'socket_connected': true,
        'location_permission': 'always',
        'queue_depth': 3,
      });
      repository.stop();
    });
  });

  test('워치 값은 받은 배치 중 가장 최근 것으로 채우고 재전달된 옛 배치는 무시한다', () {
    fakeAsync((async) {
      repository.start();
      sensorLocal.add(_batch(epochMs: 2000, battery: 60));
      // 재부팅 뒤 Data Layer 에서 다시 흘러온 옛 배치
      sensorLocal.add(_batch(epochMs: 1000, battery: 90));
      configs.add(const SensorConfig(collectionMode: 'research'));
      async.flushMicrotasks();

      expect(remote.sent.single['watch'], {
        'connected': true,
        'device_id': 'gw-test',
        'battery_pct': 60,
        'on_body': true,
        // 기준점 시각 + 마지막 샘플까지의 경과(t0 + Σdt − 기준점) 20ms
        'last_imu_ts_ms': 2020,
      });
      repository.stop();
    });
  });
}

SensorBatch _batch({required int epochMs, required int battery}) => SensorBatch(
      batchId: 'batch-$epochMs',
      deviceId: 'gw-test',
      sessionId: 'session-1',
      seq: 0,
      clock: ClockInfo(
        bootId: 'boot-1',
        clockMappingId: 'mapping-1',
        anchorElapsedNs: '1000000000',
        anchorEpochMs: epochMs,
        uncertaintyMs: 1,
      ),
      acc: const AccSeries(
        fsHzRequested: 50,
        n: 2,
        t0ElapsedNs: '1000000000',
        dtNs: [20000000],
        mg: [
          [0, 0, 1000],
          [0, 0, 1000],
        ],
      ),
      gyroMode: 'continuous',
      collectionMode: 'research',
      onBody: true,
      watchBatteryPct: battery,
    );

class _SensorLocal implements SensorBatchLocalDataSource {
  final _controller = StreamController<SensorMessage>.broadcast(sync: true);

  void add(SensorBatch batch) => _controller.add(SensorMessage.batch(batch));

  @override
  Stream<SensorMessage> getSensorBatches() => _controller.stream;

  @override
  void consume({
    required String stream,
    required String sessionId,
    required int seq,
    String? droppedStream,
  }) {}

  @override
  void consumeEvent(String eventId) {}
}

class _Device implements DeviceLocalDataSource {
  @override
  Future<String> getDeviceId() async => 'ph-test';
}

class _Status implements DeviceStatusLocalDataSource {
  bool connected = true;

  @override
  Future<Map<String, dynamic>> phoneStatus() async =>
      {'battery_pct': 71, 'charging': false};

  @override
  Future<String> appVersion() async => '1.4.2';

  @override
  Future<String> locationPermission() async => 'always';

  @override
  Future<bool> watchConnected() async => connected;

  @override
  Stream<String> networkType() => const Stream.empty();
}

class _Remote implements HeartbeatRemoteDataSource {
  final sent = <Map<String, dynamic>>[];

  @override
  Future<bool> send(Map<String, dynamic> heartbeat) async {
    sent.add(heartbeat);
    return true;
  }
}
