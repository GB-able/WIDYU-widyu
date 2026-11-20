import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/source/goal/goal_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
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
}
