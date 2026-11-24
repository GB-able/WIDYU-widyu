import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';

abstract class GoalRepository {
  Future<ApiResult<GoalHomeResponse>> fetchGoalHome();


  /// 그 달에 건강 일정이 있는 날(일).
  Future<ApiResult<Set<int>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  });

  Future<ApiResult<List<DailyMedicineSchedule>>> fetchDailyMedicines(
      DateTime date);

  Future<ApiResult<List<DailyHealthSchedule>>> fetchDailyHealthSchedules(
      DateTime date);

  Future<ApiResult<List<WalkDaily>>> fetchMonthlyWalks({
    required int year,
    required int month,
  });
}
