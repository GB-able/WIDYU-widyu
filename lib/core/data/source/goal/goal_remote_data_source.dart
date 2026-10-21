import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';

abstract class GoalRemoteDataSource {
  Future<ApiResponse<GoalHomeResponse>> fetchHomeCards();
  Future<ApiResponse<WeeklyGoalStatusResponse>> fetchWeeklyStatus();
}
