import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

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
  Future<ApiResult<List<GoalRateStatus>>> fetchWeeklyStatus() async {
    final result =
        await _goalRemoteDataSource.fetchWeeklyStatus().toApiResult();

    return switch (result) {
      Success(:final data) => ApiResult.success(data.statuses),
      Failure(:final message, :final statusCode, :final code) =>
        ApiResult.failure(message, statusCode: statusCode, code: code),
    };
  }
}
