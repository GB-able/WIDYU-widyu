import 'dart:async';
import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class MedicationRepositoryImpl extends MedicationRepository {
  final MedicationRemoteDataSource _remoteDataSource;
  final MedicationAlarmLocalDataSource _localDataSource;
  final _medicationChanges = StreamController<void>.broadcast();

  MedicationRepositoryImpl({
    required MedicationRemoteDataSource remoteDataSource,
    required MedicationAlarmLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<ApiResult<MedicationPointResult>> verifyMedication({
    required int scheduleId,
    required File proofImage,
  }) async {
    final result = await _remoteDataSource.verifyMedication(
        scheduleId: scheduleId, proofImages: [proofImage]).toApiResult();
    if (result is Success) _medicationChanges.add(null);
    return result;
  }

  @override
  Stream<void> get medicationChanges => _medicationChanges.stream;

  @override
  Future<ApiResult<MedicationSchedule>> fetchMedicationSchedule(
          String memberId) =>
      _remoteDataSource.fetchMedicationSchedule(memberId).toApiResult();

  @override
  Stream<void> get alarmChanges => _localDataSource.changes;

  @override
  Future<Map<String, dynamic>> alarmCapabilities() =>
      _localDataSource.capabilities();

  @override
  Future<Map<String, dynamic>> activateAlarm(String memberId) =>
      _localDataSource.activate(memberId);

  @override
  Future<Map<String, dynamic>> alarmState() => _localDataSource.state();

  @override
  Future<Map<String, dynamic>> activeAlarmGroup() =>
      _localDataSource.activeGroup();

  @override
  Future<Map<String, dynamic>> applyAlarmSchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  }) =>
      _localDataSource.applySchedule(
          sessionId: sessionId, schedule: schedule, groups: groups);

  @override
  Future<Map<String, dynamic>> completeAlarm({
    required String sessionId,
    required List<String> occurrenceIds,
  }) =>
      _localDataSource.complete(
          sessionId: sessionId, occurrenceIds: occurrenceIds);

  @override
  Future<void> stopAlarm(String groupId) => _localDataSource.stop(groupId);

  @override
  Future<void> clearAlarmSession() => _localDataSource.clearSession();

  @override
  Future<Map<String, dynamic>> pendingAlarmLaunch() =>
      _localDataSource.pendingLaunch();

  @override
  Future<void> acknowledgeAlarmLaunch(String eventId) =>
      _localDataSource.acknowledgeLaunch(eventId);
}
