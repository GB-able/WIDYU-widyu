import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class PointRemoteDataSourceImpl extends PointRemoteDataSource {
  final ApiClient _apiClient;

  PointRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ApiResponse<int>> fetchPoints() async {
    try {
      final response = await _apiClient.req(
        path: '/members/seniors/points',
        method: HttpMethod.get,
      );
      return response.toApiResponse((json) => json['points'] as int);
    } catch (e) {
      throw Exception('포인트 조회에 실패했습니다: $e');
    }
  }
}
