import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/walk/walk_sync_response.dart';

abstract class WalkRemoteDataSource {
  Future<ApiResponse<WalkSyncResponse>> sync({
    required int steps,
    required String date,
  });
  Future<ApiResponse<void>> setGoal(int steps);
  Future<ApiResponse<int>> fetchGoal();
}
