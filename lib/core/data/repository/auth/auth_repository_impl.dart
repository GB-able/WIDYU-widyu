import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/auth/auth_response.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDatasource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDatasource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDatasource = remoteDatasource,
        _localDataSource = localDataSource;

  @override
  Future<ApiResult<void>> login(String inviteCode, String phoneNumber) async {
    final result =
        await _remoteDatasource.login(inviteCode, phoneNumber).toApiResult();
    if (result is Success) {
      final data = (result as Success<AuthResponse>).data;
      await _localDataSource.saveAuthentication(
        data.memberId,
        data.accessToken,
        data.refreshToken,
      );
    }
    return result;
  }

  @override
  Future<ApiResult<void>> logout() async {
    final result = await _remoteDatasource.logout().toApiResult();
    if (result is Success) {
      await _localDataSource.removeAuthentication();
    }
    return result;
  }

  @override
  Future<ApiResult<String>> fetchSocketToken() async =>
      _remoteDatasource.fetchSocketToken().toApiResult();
}
