import 'dart:async';

import 'package:flutter/services.dart';

export 'src/medication_occurrence.dart';
export 'src/medication_schedule.dart';
export 'src/medication_schedule_rule.dart';

class MedicationAlarm {
  static const _channel = MethodChannel('com.widucorp.widu/medication_alarm');
  static const _events =
      EventChannel('com.widucorp.widu/medication_alarm/events');
  static final Stream<void> changes =
      _events.receiveBroadcastStream().map((_) => null).asBroadcastStream();

  Future<Map<String, dynamic>> _map(String method, [Object? args]) async =>
      Map<String, dynamic>.from(
        await _channel.invokeMapMethod<String, dynamic>(method, args) ?? {},
      );

  Future<Map<String, dynamic>> capabilities() => _map('capabilities');
  Future<Map<String, dynamic>> requestPermissions() =>
      _map('requestPermissions');
  Future<void> openSettings(String kind) =>
      _channel.invokeMethod('openSettings', {'kind': kind});
  Future<Map<String, dynamic>> activate(String memberId) =>
      _map('activate', {'memberId': memberId});
  Future<Map<String, dynamic>> state() => _map('state');
  Future<Map<String, dynamic>> activeGroup() => _map('activeGroup');
  Future<Map<String, dynamic>> applySchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  }) =>
      _map('applySchedule', {
        'sessionId': sessionId,
        'schedule': schedule,
        'groups': groups,
      });
  Future<Map<String, dynamic>> complete({
    required String sessionId,
    required List<String> occurrenceIds,
  }) =>
      _map('complete', {
        'sessionId': sessionId,
        'occurrenceIds': occurrenceIds,
      });
  Future<void> stop(String groupId) =>
      _channel.invokeMethod('stop', {'groupId': groupId});
  Future<void> clearSession() => _channel.invokeMethod('clearSession');
  Future<Map<String, dynamic>> pendingLaunch() => _map('pendingLaunch');
  Future<void> acknowledgeLaunch(String eventId) =>
      _channel.invokeMethod('acknowledgeLaunch', {'eventId': eventId});
}
