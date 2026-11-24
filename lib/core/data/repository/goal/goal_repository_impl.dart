import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';
import 'package:widyu/core/util/extension/api_result_extension.dart';

class GoalRepositoryImpl extends GoalRepository {
  final GoalRemoteDataSource _goalRemoteDataSource;

  GoalRepositoryImpl({
    required GoalRemoteDataSource goalRemoteDataSource,
  }) : _goalRemoteDataSource = goalRemoteDataSource;

  @override
  Future<ApiResult<GoalHomeResponse>> fetchGoalHome() async {
    return _goalRemoteDataSource.fetchHomeCards().toApiResult();
  }


  @override
  Future<ApiResult<Set<int>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  }) async {
    final result = await _goalRemoteDataSource
        .fetchHealthScheduleDays(year: year, month: month)
        .toApiResult();

    return switch (result) {
      Success(:final data) => ApiResult.success({
          for (final day in data)
            if (day.year == year && day.month == month) day.day,
        }),
      Failure(:final message, :final statusCode, :final code) =>
        ApiResult.failure(message, statusCode: statusCode, code: code),
    };
  }

  @override
  Future<ApiResult<List<DailyMedicineSchedule>>> fetchDailyMedicines(
          DateTime date) =>
      _goalRemoteDataSource.fetchDailyMedicines(date).toApiResult();

  @override
  Future<ApiResult<List<DailyHealthSchedule>>> fetchDailyHealthSchedules(
          DateTime date) =>
      _goalRemoteDataSource.fetchDailyHealthSchedules(date).toApiResult();

  @override
  Future<ApiResult<List<WalkDaily>>> fetchMonthlyWalks({
    required int year,
    required int month,
  }) =>
      _goalRemoteDataSource
          .fetchMonthlyWalks(year: year, month: month)
          .toApiResult();
}
