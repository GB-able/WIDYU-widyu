import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SafetyPushManager {
  SafetyPushManager._();

  static const _channel = MethodChannel('com.widucorp.widu/safety_push');

  static final _incidentArrived = StreamController<void>.broadcast();

  static Stream<void> get onIncidentArrived => _incidentArrived.stream;

  static void initialize() {
    if (!Platform.isAndroid) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onIncident') _incidentArrived.add(null);
    });
  }

  static Future<String?> consumePendingIncident() =>
      _invoke<String>('consumePendingIncident');

  static Future<void> stopAlarm(String incidentId) =>
      _invoke<void>('stopAlarm', {'incidentId': incidentId});

  static Future<void> releaseLockScreen() => _invoke<void>('releaseLockScreen');

  static Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    if (!Platform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } catch (e) {
      debugPrint('[SafetyPushManager] $method 실패: $e');
      return null;
    }
  }
}
