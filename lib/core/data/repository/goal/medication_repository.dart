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
}
