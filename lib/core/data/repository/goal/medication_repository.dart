import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

abstract class MedicationRepository {
  Future<ApiResult<MedicationPointResult>> verifyMedication({
    required int scheduleId,
    required File proofImage,
  });

  Future<ApiResult<MedicationSchedule>> fetchMedicationSchedule(
      String memberId);

  Stream<void> get alarmChanges;

  Future<Map<String, dynamic>> alarmCapabilities();

  Future<Map<String, dynamic>> activateAlarm(String memberId);

  Future<Map<String, dynamic>> alarmState();

  Future<Map<String, dynamic>> activeAlarmGroup();

  Future<Map<String, dynamic>> applyAlarmSchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  });

  Future<Map<String, dynamic>> completeAlarm({
    required String sessionId,
    required List<String> occurrenceIds,
  });

  Future<void> stopAlarm(String groupId);

  Future<void> clearAlarmSession();

  Future<Map<String, dynamic>> pendingAlarmLaunch();

  Future<void> acknowledgeAlarmLaunch(String eventId);
}
