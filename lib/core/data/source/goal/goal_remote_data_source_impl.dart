import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/util/extension/api_response_extension.dart';

class GoalRemoteDataSourceImpl extends GoalRemoteDataSource {
  final ApiClient _apiClient;

  GoalRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/goals/home';

  @override
  Future<ApiResponse<GoalHomeResponse>> fetchHomeCards() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/senior',
        method: HttpMethod.get,
      );
      return response.toApiResponse(GoalHomeResponse.fromJson);
    } catch (e) {
      throw Exception('목표 홈 조회에 실패했습니다: $e');
    }
  }
}
