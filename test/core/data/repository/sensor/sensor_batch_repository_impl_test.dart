import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/sensor/sensor_batch_repository_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';

void main() {
  late _LocalDataSource local;
  late _RemoteDataSource remote;
  late SensorBatchRepositoryImpl repository;

  setUp(() {
    local = _LocalDataSource();
    remote = _RemoteDataSource();
    repository = SensorBatchRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
      queueMax: 2,
      retryInterval: const Duration(hours: 1),
    );
    repository.observeSensorBatches();
  });

  tearDown(() {
    repository.stopObserveSensorBatches();
    local.dispose();
    remote.dispose();
  });

  test('연결 상태 배치는 즉시 STOMP로 전송하고 재전송 대기열에 남기지 않는다', () async {
    final batch = _batch(1);

    local.add(batch);
    await _settle();

    expect(remote.sent, [batch]);
    remote.connection.add(true);
    await _settle();
    expect(remote.resent, isEmpty);
  });

  test('전송 실패 배치는 연결 복구 시 resend 정보를 붙여 REST로 재전송한다', () async {
    remote.sendSucceeds = false;
    final batch = _batch(4);
    final secondBatch = _batch(5, runId: 'run-5');

    local.add(batch);
    local.add(secondBatch);
    await _settle();
    remote.connection.add(true);
    await _settle();

    final resent = remote.resent.single;
    expect(resent, hasLength(2));
    for (var index = 0; index < resent.length; index++) {
      final resentBatch = resent[index];
      final original = [batch, secondBatch][index];
      final resend = resentBatch.resend!;
      expect(resend.isResend, isTrue);
      expect(resend.originalBatchId, original.batchId);
      expect(resend.originalSeq, original.seq);
      expect(resend.originalRunId, original.runId);
      expect(resend.originalSessionId, original.sessionId);
      expect(
          resend.resentAtMs,
          inInclusiveRange(DateTime.now().millisecondsSinceEpoch - 1000,
              DateTime.now().millisecondsSinceEpoch));
      expect(resentBatch.copyWith(resend: null), original);
    }
    expect(batch.resend, isNull);

    remote.connection.add(true);
    await _settle();
    expect(remote.resent, hasLength(1));
  });

  test('대기열 상한을 넘으면 가장 오래된 배치부터 버린다', () async {
    remote.sendSucceeds = false;
    local.add(_batch(1));
    local.add(_batch(2));
    local.add(_batch(3));
    await _settle();

    remote.connection.add(true);
    await _settle();

    expect(remote.resent.single.map((batch) => batch.seq), [2, 3]);
  });

  test('REST 재전송 실패 시 대기열을 유지한다', () async {
    remote.sendSucceeds = false;
    remote.resendSucceeds = false;
    local.add(_batch(1));
    await _settle();

    remote.connection.add(true);
    await _settle();
    remote.resendSucceeds = true;
    remote.connection.add(true);
    await _settle();

    expect(remote.resent, hasLength(2));
    expect(remote.resent.last.single.seq, 1);
  });

  test('REST 진행 중 새 배치와 상한 초과는 다음 재전송에 순서대로 반영한다', () async {
    remote.sendSucceeds = false;
    final pending = Completer<bool>();
    remote.nextResend = pending.future;
    local.add(_batch(1));
    local.add(_batch(2));
    await _settle();

    remote.connection.add(true);
    await _settle();
    local.add(_batch(3));
    local.add(_batch(4));
    await _settle();
    remote.connection.add(true);
    await _settle();
    expect(remote.resent, hasLength(1));
    pending.complete(true);
    await _settle();

    remote.connection.add(true);
    await _settle();
    expect(remote.resent.last.map((batch) => batch.seq), [3, 4]);
  });

  testWidgets('재시도 타이머가 대기열을 재전송한다', (tester) async {
    repository.stopObserveSensorBatches();
    repository = SensorBatchRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
      queueMax: 2,
      retryInterval: const Duration(seconds: 1),
    )..observeSensorBatches();
    remote.sendSucceeds = false;
    local.add(_batch(1));
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));

    expect(remote.resent.single.single.seq, 1);
    repository.stopObserveSensorBatches();
  });

  test('재전송 예외 뒤에도 다음 연결 신호에서 다시 시도한다', () async {
    remote.sendSucceeds = false;
    remote.throwNextResend = true;
    local.add(_batch(1));
    await _settle();
    remote.connection.add(true);
    await _settle();
    remote.connection.add(true);
    await _settle();

    expect(remote.resent, hasLength(2));
  });

  test('폐기 레코드는 즉시 보내고 실패해도 대기열에 쌓지 않는다', () async {
    remote.sendSucceeds = false;
    local.addDropped(_dropped());
    await _settle();

    expect(remote.dropped, hasLength(1));
    remote.connection.add(true);
    await _settle();
    expect(remote.resent, isEmpty);
  });
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

SensorBatch _batch(int seq, {String? runId}) => SensorBatch(
      batchId: 'batch-$seq',
      deviceId: 'device-1',
      sessionId: 'session-1',
      seq: seq,
      runId: runId,
      bootId: 'boot-1',
      clockMappingId: 'mapping-1',
      clock: const ClockInfo(
        bootId: 'boot-1',
        clockMappingId: 'mapping-1',
        anchorElapsedNs: '123456789012345',
        anchorEpochMs: 1758000000000,
        uncertaintyMs: 1,
      ),
      acc: AccSeries(
        fsHzRequested: 50,
        n: 2,
        t0ElapsedNs: '123456789012345',
        dtNs: const [20000000],
        mg: [
          [seq, seq + 1, 1000],
          [seq + 2, seq + 3, 1001],
        ],
      ),
      gyroMode: 'continuous',
      collectionMode: 'product',
    );

SensorDroppedRecord _dropped() => const SensorDroppedRecord(
      sessionId: 'session-1',
      fromSeq: 10,
      toSeq: 15,
      reason: 'queue_full',
      tsMs: 1758000000200,
    );

class _LocalDataSource implements SensorBatchLocalDataSource {
  final _controller = StreamController<SensorMessage>.broadcast();

  void add(SensorBatch batch) => _controller.add(SensorMessage.batch(batch));

  void addDropped(SensorDroppedRecord record) =>
      _controller.add(SensorMessage.dropped(record));

  @override
  Stream<SensorMessage> getSensorBatches() => _controller.stream;

  void dispose() => _controller.close();
}

class _RemoteDataSource implements SensorBatchRemoteDataSource {
  final connection = StreamController<bool>.broadcast();
  final sent = <SensorBatch>[];
  final resent = <List<SensorBatch>>[];
  final dropped = <SensorDroppedRecord>[];
  bool sendSucceeds = true;
  bool resendSucceeds = true;
  Future<bool>? nextResend;
  bool throwNextResend = false;

  @override
  Stream<bool> get connectionState => connection.stream;

  @override
  bool sendBatch(SensorBatch batch) {
    sent.add(batch);
    return sendSucceeds;
  }

  @override
  bool sendDropped(SensorDroppedRecord record) {
    dropped.add(record);
    return sendSucceeds;
  }

  @override
  Future<bool> resendBatches(List<SensorBatch> batches) {
    resent.add(batches);
    if (throwNextResend) {
      throwNextResend = false;
      return Future<bool>.error(StateError('network failure'));
    }
    final next = nextResend;
    nextResend = null;
    return next ?? Future.value(resendSucceeds);
  }

  void dispose() => connection.close();
}
