import 'dart:io';

import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

abstract class MedicationRemoteDataSource {
  Future<ApiResponse<MedicationPointResult>> verifyMedication({
    required int scheduleId,
    required List<File> proofImages,
  });
}
