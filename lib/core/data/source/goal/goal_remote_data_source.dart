import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';

abstract class GoalRemoteDataSource {
  Future<ApiResponse<GoalHomeResponse>> fetchHomeCards();

  /// 건강 일정이 있는 날짜. 하루에 일정이 여러 개면 같은 날짜가 여러 번 온다.
  Future<ApiResponse<List<DateTime>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  });

  Future<ApiResponse<List<DailyMedicineSchedule>>> fetchDailyMedicines(
      DateTime date);

  Future<ApiResponse<List<DailyHealthSchedule>>> fetchDailyHealthSchedules(
      DateTime date);

  Future<ApiResponse<List<WalkDaily>>> fetchMonthlyWalks({
    required int year,
    required int month,
  });
}
