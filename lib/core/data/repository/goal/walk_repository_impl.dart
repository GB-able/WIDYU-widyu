import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class WalkRepositoryImpl extends WalkRepository {
  final WalkLocalDataSource _localDataSource;
  final WalkRemoteDataSource _remoteDataSource;

  WalkRepositoryImpl({
    required WalkLocalDataSource localDataSource,
    required WalkRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<bool> ensurePermission() => _localDataSource.ensurePermission();

  @override
  Stream<int> observeStepDelta() => _localDataSource.observeStepDelta();

  @override
  Future<ApiResult<bool>> syncSteps(int steps) =>
      _remoteDataSource.syncSteps(steps).toApiResult();
}
