import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:widyu/core/data/repository/sensor/sensor_batch_repository.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';
import 'package:widyu/core/model/sensor/sensor_batch_config.dart';
import 'package:widyu/core/model/sensor/sensor_result.dart';

class SensorBatchRepositoryImpl implements SensorBatchRepository {
  SensorBatchRepositoryImpl({
    required SensorBatchLocalDataSource localDataSource,
    required SensorBatchRemoteDataSource remoteDataSource,
    int queueMax = SensorBatchConfig.queueMax,
    Duration retryInterval = SensorBatchConfig.retryInterval,
    Duration ackTimeout = SensorBatchConfig.ackTimeout,
    Duration maxAckWait = SensorBatchConfig.maxAckWait,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _queueMax = queueMax,
        _retryInterval = retryInterval,
        _ackTimeout = ackTimeout,
        _maxAckWait = maxAckWait {
    assert(queueMax > 0, 'queueMax must be positive');
    assert(!retryInterval.isNegative && retryInterval > Duration.zero,
        'retryInterval must be positive');
  }

  final SensorBatchLocalDataSource _localDataSource;
  final SensorBatchRemoteDataSource _remoteDataSource;
  final int _queueMax;
  final Duration _retryInterval;
  final Duration _ackTimeout;
  final Duration _maxAckWait;
  final ListQueue<SensorUpload> _queue = ListQueue();

  /// 결과를 기다리는 배치. 삽입 순서를 쓰므로 LinkedHashMap 기본 구현에 의존한다.
  final Map<String, ({SensorUpload batch, DateTime sentAt})> _pending = {};
  StreamSubscription<SensorMessage>? _batches;
  StreamSubscription<bool>? _connection;
  StreamSubscription<SensorResult>? _results;
  Timer? _retryTimer;
  bool _active = false;
  bool _isResending = false;
  DateTime? _lastResultAt;

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
      // 결과가 계속 오고 있으면 서버가 몰린 배치를 처리하는 중이다. 이때 REST 로 넘기면 같은 배치를 두 번 보낸다.
      final now = DateTime.now();
      final lastResultAt = _lastResultAt;
      final stalled =
          lastResultAt == null || now.difference(lastResultAt) >= _ackTimeout;
      _flushPending((sentAt) {
        final waited = now.difference(sentAt);
        return waited >= _maxAckWait || (stalled && waited >= _ackTimeout);
      });
      _resendQueued();
    });
  }

  void _onMessage(SensorMessage message) {
    if (!_active) return;
    switch (message) {
      case SensorMessageBatch(:final batch):
        _send(batch);
      case SensorMessageHeartRate(:final batch):
        _send(batch);
      // 폐기 레코드는 결과가 오지 않아 보내지는 대로 지운다. 못 보내면 남겨 두어 다음 기동 때 다시 보낸다.
      case SensorMessageDropped(:final record):
        if (_remoteDataSource.sendDropped(record)) {
          _localDataSource.consume(
            stream: record.stream,
            sessionId: record.sessionId,
            seq: record.fromSeq,
          );
        } else {
          log('Sensor dropped record send failed: '
              'session=${record.sessionId} '
              'seq=${record.fromSeq}..${record.toSeq}');
        }
    }
  }

  void _send(SensorUpload batch) {
    if (_remoteDataSource.sendBatch(batch)) {
      _addPending(batch);
    } else {
      _enqueue(batch);
    }
  }

  /// 결과가 늦게 와서 이미 REST 대기열로 넘어간 배치도 여기서 빼야 REST 가 다시 보내지 않는다.
  void _onResult(SensorResult result) {
    _lastResultAt = DateTime.now();
    final removed =
        _pending.remove(result.batchId)?.batch ?? _removeQueued(result.batchId);
    if (result.result == SensorResult.rejected) {
      log('Sensor batch rejected seq=${removed?.seq ?? result.seq}');
    }
    if (removed != null) _consume(removed);
  }

  SensorUpload? _removeQueued(String batchId) {
    final batch =
        _queue.where((queued) => queued.batchId == batchId).firstOrNull;
    if (batch != null) _queue.remove(batch);
    return batch;
  }

  /// 서버가 최종 판정(저장·중복·거절)을 내린 배치만 워치 Data Layer 에서 지운다.
  void _consume(SensorUpload batch) => _localDataSource.consume(
        stream: batch.stream,
        sessionId: batch.sessionId,
        seq: batch.seq,
      );

  void _addPending(SensorUpload batch) {
    if (_pending.length >= _queueMax) {
      final oldest = _pending.keys.first;
      final dropped = _pending.remove(oldest);
      // Data Layer 에는 남아 있어 다음 기동 때 다시 흘러온다.
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

  void _enqueue(SensorUpload batch) {
    if (_queue.length == _queueMax) {
      final dropped = _queue.removeFirst();
      // Data Layer 에는 남아 있어 다음 기동 때 다시 흘러온다.
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
        _consume(batch);
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
    // 지우지 않은 항목은 다음 구독 때 네이티브가 Data Layer 에서 다시 흘려준다. 남겨 두면 두 번 보낸다.
    _pending.clear();
    _queue.clear();
  }
}
