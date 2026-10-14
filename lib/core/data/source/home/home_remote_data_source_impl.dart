import 'dart:io';

import 'package:dio/dio.dart';
import 'package:widyu/core/data/source/home/home_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/home/medication_verification.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const _path = '/home/senior/cards';

  @override
  Future<ApiResponse<SeniorCard>> fetchSeniorCard() async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.get,
      );
      return response.toApiResponse(SeniorCard.fromJson);
    } catch (e) {
      throw Exception("시니어 카드 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<MedicationVerification>> verifyMedication(
    int scheduleId,
    File image,
  ) async {
    try {
      final formData = FormData.fromMap({
        'medicationProofImage': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      final response = await _apiClient.req(
        path: '/goals/medicine-schedules/$scheduleId/verify',
        method: HttpMethod.post,
        body: formData,
      );
      return response.toApiResponse(MedicationVerification.fromJson);
    } catch (e) {
      throw Exception("약 복용 인증에 실패했습니다: $e");
    }
  }
}
