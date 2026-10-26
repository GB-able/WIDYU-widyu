import 'package:flutter/services.dart';

class WalkRecording {
  static const _channel = MethodChannel('com.widucorp.widu/walk');

  Future<bool> isAvailable() async =>
      await _channel.invokeMethod<bool>('isAvailable') ?? false;

  Future<void> startRecording() =>
      _channel.invokeMethod<void>('startRecording');

  Future<void> stopRecording() => _channel.invokeMethod<void>('stopRecording');

  Future<int?> readSteps(DateTime start, DateTime end) =>
      _channel.invokeMethod<int>('readSteps', {
        'startMillis': start.millisecondsSinceEpoch,
        'endMillis': end.millisecondsSinceEpoch,
      });
}
