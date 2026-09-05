import 'dart:io';

import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/medicine/medicine_point_result.dart';

abstract class MedicineRemoteDataSource {
  Future<ApiResponse<MedicinePointResult>> verifyMedication({
    required int scheduleId,
    required List<File> proofImages,
  });
}
