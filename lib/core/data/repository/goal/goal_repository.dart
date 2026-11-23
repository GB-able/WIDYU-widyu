import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';

abstract class GoalRepository {
  Future<ApiResult<GoalHomeResponse>> fetchGoalHome();
}
