import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source.dart';

class MedicationAlarmLocalDataSourceImpl
    implements MedicationAlarmLocalDataSource {
  final MedicationAlarm _alarm = MedicationAlarm();

  @override
  Stream<void> get changes => MedicationAlarm.changes;

  @override
  Future<Map<String, dynamic>> capabilities() => _alarm.capabilities();

  @override
  Future<Map<String, dynamic>> activate(String memberId) =>
      _alarm.activate(memberId);

  @override
  Future<Map<String, dynamic>> state() => _alarm.state();

  @override
  Future<Map<String, dynamic>> activeGroup() => _alarm.activeGroup();

  @override
  Future<Map<String, dynamic>> applySchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  }) =>
      _alarm.applySchedule(
          sessionId: sessionId, schedule: schedule, groups: groups);

  @override
  Future<Map<String, dynamic>> complete({
    required String sessionId,
    required List<String> occurrenceIds,
  }) =>
      _alarm.complete(sessionId: sessionId, occurrenceIds: occurrenceIds);

  @override
  Future<void> stop(String groupId) => _alarm.stop(groupId);

  @override
  Future<void> clearSession() => _alarm.clearSession();

  @override
  Future<Map<String, dynamic>> pendingLaunch() => _alarm.pendingLaunch();

  @override
  Future<void> acknowledgeLaunch(String eventId) =>
      _alarm.acknowledgeLaunch(eventId);
}
