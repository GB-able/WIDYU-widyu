import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class PointRepositoryImpl extends PointRepository {
  final PointRemoteDataSource _remoteDataSource;

  PointRepositoryImpl({required PointRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<int>> fetchPoints() async =>
      await _remoteDataSource.fetchPoints().toApiResult();
}
