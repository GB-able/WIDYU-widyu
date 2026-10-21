import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

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
      throw Exception("목표 홈 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<WeeklyGoalStatusResponse>> fetchWeeklyStatus() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/senior/weekly-status',
        method: HttpMethod.get,
      );
      return response.toApiResponse(WeeklyGoalStatusResponse.fromJson);
    } catch (e) {
      throw Exception("이번 주 목표 달성률 조회에 실패했습니다: $e");
    }
  }
}
