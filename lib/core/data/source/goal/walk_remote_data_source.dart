import 'package:widyu/core/model/api/api_response.dart';

abstract class WalkRemoteDataSource {
  Future<ApiResponse<bool>> syncSteps(int steps);
  Future<ApiResponse<void>> setGoal({required int steps, int? memberId});
  Future<ApiResponse<int>> fetchGoal({int? memberId});
}
