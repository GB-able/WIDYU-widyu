import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';

class HeartRateLocalDataSourceImpl implements HeartRateLocalDataSource {
  static const _eventChannel = EventChannel("com.example.widyu/heart_rate");
  static const _methodChannel =
      MethodChannel("com.example.widyu/heart_rate_status");

  @override
  Stream<HeartRate> getHeartRates() {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      final data = event as Map<dynamic, dynamic>;
      return HeartRate(
          heartRate: data['heartRate'] as int,
          measuredAt:
              DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int));
    });
  }

  @override
  Future<void> sendHeartRateStatus(String heartRateStatus) async {
    try {
      await _methodChannel.invokeMethod(
          'fetchHeartRateStatus', {'heartRateStatus': heartRateStatus});
    } on PlatformException catch (e) {
      log("Error in sendHeartRateStatus: ${e.message}");
    }
  }

  @override
  Stream<bool> observeConnection() =>
      _eventChannel.receiveBroadcastStream().map((_) => true).timeout(
            const Duration(seconds: 30),
            onTimeout: (sink) => sink.add(false),
          );
}
