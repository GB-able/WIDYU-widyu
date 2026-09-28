import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:widyu/core/data/repository/sensor/sensor_batch_repository.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
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
  final ListQueue<Map<String, dynamic>> _queue = ListQueue();
  StreamSubscription<Map<String, dynamic>>? _batches;
  StreamSubscription<bool>? _connection;
  Timer? _retryTimer;
  bool _active = false;
  bool _isResending = false;

  @override
  void observeSensorBatches() {
    if (_active) return;
    _active = true;
    _batches = _localDataSource.getSensorBatches().listen(
          _onBatch,
          onError: (Object error, StackTrace stackTrace) =>
              log('Sensor batch stream error: $error', stackTrace: stackTrace),
        );
    _connection = _remoteDataSource.connectionState.listen((connected) {
      if (connected) _resendQueued();
    });
    _retryTimer = Timer.periodic(_retryInterval, (_) => _resendQueued());
  }

  void _onBatch(Map<String, dynamic> batch) {
    if (!_active) return;
    if (!_remoteDataSource.sendBatch(batch)) _enqueue(batch);
  }

  void _enqueue(Map<String, dynamic> batch) {
    if (_queue.length == _queueMax) {
      final dropped = _queue.removeFirst();
      log('Sensor batch resend queue full; dropped oldest seq=${dropped['seq']}');
    }
    _queue.addLast(batch);
  }

  Future<void> _resendQueued() async {
    if (!_active || _isResending || _queue.isEmpty) return;
    _isResending = true;
    // Keep references to queued originals. New arrivals stay queued while REST is in flight.
    final originals = List<Map<String, dynamic>>.of(_queue);
    final resent = originals.map(_withResend).toList(growable: false);
    var succeeded = false;
    try {
      succeeded = await _remoteDataSource.resendBatches(resent);
      if (succeeded) {
        final sent = Set<Map<String, dynamic>>.identity()..addAll(originals);
        _queue.removeWhere(sent.contains);
      }
    } catch (error, stackTrace) {
      log('Sensor batch resend failed: $error', stackTrace: stackTrace);
    } finally {
      _isResending = false;
    }
    if (succeeded && _active && _queue.isNotEmpty) _resendQueued();
  }

  Map<String, dynamic> _withResend(Map<String, dynamic> batch) => {
        ...batch,
        'resend': {
          'is_resend': true,
          'original_batch_id': batch['batch_id'],
          'original_seq': batch['seq'],
          'original_run_id': batch['run_id'],
          'original_session_id': batch['session_id'],
          'resent_at_ms': DateTime.now().millisecondsSinceEpoch,
        },
      };

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
