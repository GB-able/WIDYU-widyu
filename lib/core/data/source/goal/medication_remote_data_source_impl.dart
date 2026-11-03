import 'dart:io';

import 'package:dio/dio.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class MedicationRemoteDataSourceImpl extends MedicationRemoteDataSource {
  final ApiClient _apiClient;

  MedicationRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/goals/medicine-schedules';

  @override
  Future<ApiResponse<MedicationPointResult>> verifyMedication({
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
      return response.toApiResponse(MedicationPointResult.fromJson);
    } catch (e) {
      throw Exception('약 복용 인증에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<MedicationSchedule>> fetchMedicationSchedule(
      String memberId) async {
    final response = await _apiClient.req(
      path: '$_path/alarm-sync',
      method: HttpMethod.get,
    );
    return response.toApiResponse(
        (json) => MedicationSchedule.fromJson({'memberId': memberId, ...json}));
  }
}
