import 'dart:io';

import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/medicine/medicine_point_result.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';

abstract class GoalRepository {
  Future<ApiResult<GoalHomeResponse>> fetchGoalHome();

  Future<ApiResult<List<GoalRateStatus>>> fetchWeeklyStatus();

  Future<ApiResult<MedicinePointResult>> verifyMedication({
    required int scheduleId,
    required File proofImage,
  });
}
