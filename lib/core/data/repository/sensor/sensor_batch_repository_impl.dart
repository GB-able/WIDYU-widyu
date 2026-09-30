import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:widyu/core/data/repository/sensor/sensor_batch_repository.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_batch_config.dart';

class SensorBatchRepositoryImpl implements SensorBatchRepository {
  SensorBatchRepositoryImpl({
    required SensorBatchLocalDataSource localDataSource,
    required SensorBatchRemoteDataSource remoteDataSource,
    int queueMax = SensorBatchConfig.queueMax,
    Duration retryInterval = SensorBatchConfig.retryInterval,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _queueMax = queueMax,
        _retryInterval = retryInterval {
    assert(queueMax > 0, 'queueMax must be positive');
    assert(!retryInterval.isNegative && retryInterval > Duration.zero,
        'retryInterval must be positive');
  }

  final SensorBatchLocalDataSource _localDataSource;
  final SensorBatchRemoteDataSource _remoteDataSource;
  final int _queueMax;
  final Duration _retryInterval;
  final ListQueue<SensorBatch> _queue = ListQueue();
  StreamSubscription<SensorMessage>? _batches;
  StreamSubscription<bool>? _connection;
  Timer? _retryTimer;
  bool _active = false;
  bool _isResending = false;

  @override
  void observeSensorBatches() {
    if (_active) return;
    _active = true;
    _batches = _localDataSource.getSensorBatches().listen(
          _onMessage,
          onError: (Object error, StackTrace stackTrace) =>
              log('Sensor batch stream error: $error', stackTrace: stackTrace),
        );
    _connection = _remoteDataSource.connectionState.listen((connected) {
      if (connected) _resendQueued();
    });
    _retryTimer = Timer.periodic(_retryInterval, (_) => _resendQueued());
  }

  void _onMessage(SensorMessage message) {
    if (!_active) return;
    switch (message) {
      case SensorMessageBatch(:final batch):
        if (!_remoteDataSource.sendBatch(batch)) _enqueue(batch);
      // 폐기 레코드는 재전송 대상이 아니다 — 서버 수용 여부가 미정이라 실패는 기록만 한다.
      case SensorMessageDropped(:final record):
        if (!_remoteDataSource.sendDropped(record)) {
          log('Sensor dropped record send failed: '
              'session=${record.sessionId} '
              'seq=${record.fromSeq}..${record.toSeq}');
        }
    }
  }

  void _enqueue(SensorBatch batch) {
    if (_queue.length == _queueMax) {
      final dropped = _queue.removeFirst();
      log('Sensor batch resend queue full; dropped oldest seq=${dropped.seq}');
    }
    _queue.addLast(batch);
  }

  Future<void> _resendQueued() async {
    if (!_active || _isResending || _queue.isEmpty) return;
    _isResending = true;
    // Keep references to queued originals. New arrivals stay queued while REST is in flight.
    final originals = List<SensorBatch>.of(_queue);
    final resent = originals.map(_withResend).toList(growable: false);
    var succeeded = false;
    try {
      succeeded = await _remoteDataSource.resendBatches(resent);
      if (succeeded) {
        final sent = Set<SensorBatch>.identity()..addAll(originals);
        _queue.removeWhere(sent.contains);
      }
    } catch (error, stackTrace) {
      log('Sensor batch resend failed: $error', stackTrace: stackTrace);
    } finally {
      _isResending = false;
    }
    if (succeeded && _active && _queue.isNotEmpty) _resendQueued();
  }

  SensorBatch _withResend(SensorBatch batch) => batch.copyWith(
        resend: ResendInfo(
          isResend: true,
          originalBatchId: batch.batchId,
          originalSeq: batch.seq,
          originalRunId: batch.runId,
          originalSessionId: batch.sessionId,
          resentAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );

  @override
  void stopObserveSensorBatches() {
    _active = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    _batches?.cancel();
    _batches = null;
    _connection?.cancel();
    _connection = null;
  }
}
