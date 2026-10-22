import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class HeartRateRemoteDataSourceImpl implements HeartRateRemoteDataSource {
  final ApiClient _apiClient;

  HeartRateRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const _path = '/heart-rate/status';

  @override
  Future<ApiResponse<HeartRateResponse>> fetchHeartRateStatus() async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.get,
        query: {'memberId': ''},
      );
      return response.toApiResponse(HeartRateResponse.fromJson);
    } catch (e) {
      throw Exception('Failed to Fetch Heart Rate Status: $e');
    }
  }
}
