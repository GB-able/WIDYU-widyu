import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

abstract class MedicationRepository {
  Stream<void> get medicationChanges;

  Stream<void> get alarmChanges;

  Future<MedicationPointResult> verifyMedication(
      MedicationOccurrence occurrence, File proofImage);

  Future<void> syncAlarmSchedule();

  Future<Map<String, dynamic>> alarmCapabilities();

  Future<Map<String, dynamic>> requestAlarmPermission();

  Future<Map<String, dynamic>> activateAlarm(String memberId);

  Future<Map<String, dynamic>> alarmState();

  Future<Map<String, dynamic>> activeAlarmGroup();

  Future<void> stopAlarm(String groupId);

  Future<void> clearAlarmSession();

  Future<Map<String, dynamic>> pendingAlarmLaunch();

  Future<void> acknowledgeAlarmLaunch(String eventId);
}
