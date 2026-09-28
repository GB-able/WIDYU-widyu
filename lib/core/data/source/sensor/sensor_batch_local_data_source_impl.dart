import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';

class SensorBatchLocalDataSourceImpl implements SensorBatchLocalDataSource {
  static const _eventChannel = EventChannel('com.gbable.widu/sensor_batch');

  late final Stream<Map<String, dynamic>> _sensorBatchStream = _eventChannel
      .receiveBroadcastStream()
      .map((event) =>
          Map<String, dynamic>.from(jsonDecode(event as String) as Map));

  @override
  Stream<Map<String, dynamic>> getSensorBatches() => _sensorBatchStream;
}
