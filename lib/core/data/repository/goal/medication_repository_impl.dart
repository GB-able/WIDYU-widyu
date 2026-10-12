import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class MedicationRepositoryImpl extends MedicationRepository {
  final MedicationRemoteDataSource _remoteDataSource;

  MedicationRepositoryImpl({
    required MedicationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<MedicationPointResult>> verifyMedication({
    required int scheduleId,
    required File proofImage,
  }) async =>
      await _remoteDataSource.verifyMedication(
          scheduleId: scheduleId, proofImages: [proofImage]).toApiResult();

  @override
  Future<ApiResult<MedicationSchedule>> fetchMedicationSchedule(
          String memberId) =>
      _remoteDataSource.fetchMedicationSchedule(memberId).toApiResult();
}
