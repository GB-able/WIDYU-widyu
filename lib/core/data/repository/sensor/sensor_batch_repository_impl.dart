import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:widyu/core/data/repository/sensor/sensor_batch_repository.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_batch_config.dart';
import 'package:widyu/core/model/sensor/sensor_result.dart';

class SensorBatchRepositoryImpl implements SensorBatchRepository {
  SensorBatchRepositoryImpl({
    required SensorBatchLocalDataSource localDataSource,
    required SensorBatchRemoteDataSource remoteDataSource,
    int queueMax = SensorBatchConfig.queueMax,
    Duration retryInterval = SensorBatchConfig.retryInterval,
    Duration ackTimeout = SensorBatchConfig.ackTimeout,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _queueMax = queueMax,
        _retryInterval = retryInterval,
        _ackTimeout = ackTimeout {
    assert(queueMax > 0, 'queueMax must be positive');
    assert(!retryInterval.isNegative && retryInterval > Duration.zero,
        'retryInterval must be positive');
  }

  final SensorBatchLocalDataSource _localDataSource;
  final SensorBatchRemoteDataSource _remoteDataSource;
  final int _queueMax;
  final Duration _retryInterval;
  final Duration _ackTimeout;
  final ListQueue<SensorBatch> _queue = ListQueue();

  /// 결과를 기다리는 배치. 삽입 순서를 쓰므로 LinkedHashMap 기본 구현에 의존한다.
  final Map<String, ({SensorBatch batch, DateTime sentAt})> _pending = {};
  StreamSubscription<SensorMessage>? _batches;
  StreamSubscription<bool>? _connection;
  StreamSubscription<SensorResult>? _results;
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
    _results = _remoteDataSource.results.listen(_onResult);
    _connection = _remoteDataSource.connectionState.listen((connected) {
      // 끊기면 서버 쪽 구독도 사라져 결과가 영영 안 오므로 전부 REST 재전송으로 돌린다.
      if (connected) {
        _resendQueued();
      } else {
        _flushPending((_) => true);
      }
    });
    _retryTimer = Timer.periodic(_retryInterval, (_) {
      final deadline = DateTime.now().subtract(_ackTimeout);
      _flushPending((sentAt) => !sentAt.isAfter(deadline));
      _resendQueued();
    });
  }

  void _onMessage(SensorMessage message) {
    if (!_active) return;
    switch (message) {
      case SensorMessageBatch(:final batch):
        if (_remoteDataSource.sendBatch(batch)) {
          _addPending(batch);
        } else {
          _enqueue(batch);
        }
      // 폐기 레코드는 재전송 대상이 아니다 — 서버 수용 여부가 미정이라 실패는 기록만 한다.
      case SensorMessageDropped(:final record):
        if (!_remoteDataSource.sendDropped(record)) {
          log('Sensor dropped record send failed: '
              'session=${record.sessionId} '
              'seq=${record.fromSeq}..${record.toSeq}');
        }
    }
  }

  void _onResult(SensorResult result) {
    final removed = _pending.remove(result.batchId);
    if (result.result == SensorResult.rejected) {
      log('Sensor batch rejected seq=${removed?.batch.seq ?? result.seq}');
    }
  }

  void _addPending(SensorBatch batch) {
    if (_pending.length >= _queueMax) {
      final oldest = _pending.keys.first;
      final dropped = _pending.remove(oldest);
      log('Sensor batch ack wait full; dropped oldest seq=${dropped?.batch.seq}');
    }
    _pending[batch.batchId] = (batch: batch, sentAt: DateTime.now());
  }

  void _flushPending(bool Function(DateTime sentAt) shouldFlush) {
    if (_pending.isEmpty) return;
    final flushed = _pending.entries
        .where((entry) => shouldFlush(entry.value.sentAt))
        .toList();
    for (final entry in flushed) {
      _pending.remove(entry.key);
      _enqueue(entry.value.batch);
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
    // retryLater 면 멈춰 순서를 지키고 다음 연결 신호·재시도 타이머에 다시 시도한다.
    try {
      while (_active && _queue.isNotEmpty) {
        final batch = _queue.first;
        final outcome = await _remoteDataSource.resendBatch(batch);
        if (outcome == ResendOutcome.retryLater) return;
        if (outcome == ResendOutcome.rejected) {
          log('Sensor batch rejected seq=${batch.seq}');
        }
        // await 사이에 큐가 바뀌었을 수 있으므로 같은 객체일 때만 뺀다.
        if (_queue.isNotEmpty && identical(_queue.first, batch)) {
          _queue.removeFirst();
        }
      }
    } catch (error, stackTrace) {
      log('Sensor batch resend failed: $error', stackTrace: stackTrace);
    } finally {
      _isResending = false;
    }
  }

  @override
  void stopObserveSensorBatches() {
    _active = false;
    _retryTimer?.cancel();
    _retryTimer = null;
    _batches?.cancel();
    _batches = null;
    _connection?.cancel();
    _connection = null;
    _results?.cancel();
    _results = null;
    _pending.clear();
  }
}
