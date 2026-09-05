import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class WalkRemoteDataSourceImpl extends WalkRemoteDataSource {
  final ApiClient _apiClient;

  WalkRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/goals/walks';

  @override
  Future<ApiResponse<bool>> syncSteps(int steps) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/sync',
        method: HttpMethod.post,
        body: {'steps': steps},
      );
      return response
          .toApiResponse<bool>((json) => json['achieved'] as bool? ?? false);
    } catch (e) {
      throw Exception("걸음 수 연동에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> setGoal({
    required int steps,
    int? memberId,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/goal',
        method: HttpMethod.post,
        body: {'steps': steps},
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("걷기 목표 설정에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<int>> fetchGoal({int? memberId}) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/upcoming-goal',
        method: HttpMethod.get,
      );
      return response.toApiResponse<int>((json) => json['steps'] as int? ?? 0);
    } catch (e) {
      throw Exception("목표 걸음 수 조회에 실패했습니다: $e");
    }
  }
}
