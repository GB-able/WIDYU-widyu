import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/device/device_event_repository_impl.dart';
import 'package:widyu/core/data/source/device/device_event_remote_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

void main() {
  // 저장소 기본 주기와 같다.
  const interval = Duration(minutes: 1);
  late _LocalDataSource local;
  late _RemoteDataSource remote;
  late DeviceEventRepositoryImpl repository;

  setUp(() {
    local = _LocalDataSource();
    remote = _RemoteDataSource();
    repository = DeviceEventRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
    );
  });

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

  @override
  Future<List<String>?> send(List<Map<String, dynamic>> events) async {
    sentIds.add([for (final event in events) event['event_id'] as String]);
    return results;
  }
}
