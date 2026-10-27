import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/walk/walk_sync_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class WalkRemoteDataSourceImpl extends WalkRemoteDataSource {
  WalkRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  static const String _path = '/goals/walks';

  @override
  Future<ApiResponse<WalkSyncResponse>> sync({
    required int steps,
    required String date,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/sync',
        method: HttpMethod.post,
        body: {'date': date, 'steps': steps},
      );
      return response.toApiResponse(WalkSyncResponse.fromJson);
    } catch (e) {
      throw Exception('걸음 수 동기화에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<void>> setGoal(int steps) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/goal',
        method: HttpMethod.post,
        body: {'steps': steps},
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception('걷기 목표 설정에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<int>> fetchGoal() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/upcoming-goal',
        method: HttpMethod.get,
      );
      return response.toApiResponse<int>((json) => json['steps'] as int? ?? 0);
    } catch (e) {
      throw Exception('목표 걸음 수 조회에 실패했습니다: $e');
    }
  }
}
