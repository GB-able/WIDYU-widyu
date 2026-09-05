import 'dart:io';

import 'package:dio/dio.dart';
import 'package:widyu/core/data/source/goal/medicine_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/medicine/medicine_point_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class MedicineRemoteDataSourceImpl extends MedicineRemoteDataSource {
  final ApiClient _apiClient;

  MedicineRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/goals/medicine-schedules';

  @override
  Future<ApiResponse<MedicinePointResult>> verifyMedication({
    required int scheduleId,
    required List<File> proofImages,
  }) async {
    try {
      final formData = FormData();
      for (final image in proofImages) {
        formData.files.add(MapEntry(
          'medicationProofImage',
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        ));
      }
      final response = await _apiClient.req(
        path: '$_path/$scheduleId/verify',
        method: HttpMethod.post,
        body: formData,
      );
      return response.toApiResponse(MedicinePointResult.fromJson);
    } catch (e) {
      throw Exception("약 복용 인증에 실패했습니다: $e");
    }
  }
}
