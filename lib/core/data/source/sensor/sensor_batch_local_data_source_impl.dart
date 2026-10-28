import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

class SensorBatchLocalDataSourceImpl implements SensorBatchLocalDataSource {
  static const _eventChannel = EventChannel('com.widucorp.widu/sensor_batch');
  static const _ackChannel = MethodChannel('com.widucorp.widu/sensor_batch_ack');

  late final Stream<SensorMessage> _sensorBatchStream = _eventChannel
      .receiveBroadcastStream()
      .map((event) => _parse(event as String))
      .where((message) => message != null)
      .cast<SensorMessage>();

  /// 한 건이 깨져도 스트림은 살려 두고, 서버가 워치→폰 지연을 볼 수 있도록 수신 시각을 채운다.
  static SensorMessage? _parse(String raw) {
    try {
      final message =
          SensorMessage.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      final receivedAt = DateTime.now().millisecondsSinceEpoch;
      return switch (message) {
        SensorMessageBatch(:final batch) => SensorMessage.batch(
            batch.copyWith(phoneReceivedAtMs: receivedAt),
          ),
        SensorMessageHeartRate(:final batch) => SensorMessage.heartRate(
            batch.copyWith(phoneReceivedAtMs: receivedAt),
          ),
        SensorMessageDropped() => message,
      };
    } catch (error, stackTrace) {
      // 파싱 예외 메시지는 원문 센서 값을 품을 수 있어 고정 문구로 남긴다.
      WiduLog.data.w('센서 메시지 파싱 실패 ${error.runtimeType}',
          error: error, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Stream<SensorMessage> getSensorBatches() => _sensorBatchStream;

  @override
  void consume({
    required String stream,
    required String sessionId,
    required int seq,
  }) {
    _ackChannel.invokeMethod<void>('consume', {
      'stream': stream,
      'session_id': sessionId,
      'seq': seq,
    }).catchError((Object error, StackTrace stack) {
      // 못 지우면 다음 기동 때 다시 보내질 뿐이고, 서버가 batch_id 로 중복을 거른다.
      WiduLog.data.w('센서 항목 소비 실패 seq=$seq', error: error, stackTrace: stack);
    });
  }
}
