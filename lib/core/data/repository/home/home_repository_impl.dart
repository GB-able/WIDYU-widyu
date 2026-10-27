import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/source/home/home_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<SeniorCard>> fetchSeniorCard() async =>
      _remoteDataSource.fetchSeniorCard().toApiResult();
}
