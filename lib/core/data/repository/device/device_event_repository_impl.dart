import 'dart:async';

import 'package:widyu/core/data/repository/device/device_event_repository.dart';
import 'package:widyu/core/data/source/device/device_event_remote_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

class DeviceEventRepositoryImpl implements DeviceEventRepository {
  DeviceEventRepositoryImpl({
    required SensorBatchLocalDataSource localDataSource,
    required DeviceEventRemoteDataSource remoteDataSource,
    Duration flushInterval = const Duration(minutes: 1),
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _flushInterval = flushInterval;

  /// 서버가 한 번에 받는 최대 개수.
  static const maxBatch = 500;

  final SensorBatchLocalDataSource _localDataSource;
  final DeviceEventRemoteDataSource _remoteDataSource;
  final Duration _flushInterval;

  /// event_id 기준. 재전달로 같은 이벤트가 다시 와도 한 번만 보낸다. 삽입 순서를 쓴다.
  final Map<String, Map<String, dynamic>> _pending = {};
  StreamSubscription<SensorMessage>? _events;
  Timer? _timer;
  bool _sending = false;

  @override
  void start() {
    if (_events != null) return;
    _events = _localDataSource.getSensorBatches().listen((message) {
      if (message is! SensorMessageDeviceEvent) return;
      final eventId = message.event['event_id'];
      if (eventId is! String) {
        WiduLog.data.w('event_id 없는 기기 이벤트');
        return;
      }
      _pending.putIfAbsent(eventId, () => message.event);
      if (_pending.length >= maxBatch) unawaited(_flush());
    });
    _timer = Timer.periodic(_flushInterval, (_) => unawaited(_flush()));
  }

  /// 결과를 받은 항목은 결과가 무엇이든 워치에서 지운다. 거절은 다시 보내도 같다.
  Future<void> _flush() async {
    if (_sending || _pending.isEmpty) return;
    _sending = true;
    try {
      final batch = _pending.entries.take(maxBatch).toList();
      final results =
          await _remoteDataSource.send([for (final e in batch) e.value]);
      // 실패면 남겨 두었다가 다음 주기에 같은 묶음을 다시 보낸다. 저장된 항목은 DUPLICATE 로 온다.
      if (results == null) return;
      var rejected = 0;
      for (var i = 0; i < results.length && i < batch.length; i++) {
        final eventId = batch[i].key;
        if (results[i] == 'REJECTED') rejected++;
        _pending.remove(eventId);
        _localDataSource.consumeEvent(eventId);
      }
      if (rejected > 0) WiduLog.data.w('기기 이벤트 거절 count=$rejected');
    } finally {
      _sending = false;
    }
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _events?.cancel();
    _events = null;
    // 지우지 않은 항목은 다음 구독 때 네이티브가 Data Layer 에서 다시 흘려준다.
    _pending.clear();
  }
}
