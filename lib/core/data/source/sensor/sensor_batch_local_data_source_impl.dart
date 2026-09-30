import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';

class SensorBatchLocalDataSourceImpl implements SensorBatchLocalDataSource {
  static const _eventChannel = EventChannel('com.gbable.widu/sensor_batch');

  late final Stream<SensorMessage> _sensorBatchStream = _eventChannel
      .receiveBroadcastStream()
      .map((event) => _parse(event as String))
      .where((message) => message != null)
      .cast<SensorMessage>();

  /// 한 건이 깨져도 스트림은 살려 둔다.
  static SensorMessage? _parse(String raw) {
    try {
      return SensorMessage.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error, stackTrace) {
      log('Sensor message parse failed: $error', stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Stream<SensorMessage> getSensorBatches() => _sensorBatchStream;
}
