import 'package:widyu/core/data/datasources/auth_remote_data_source.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/data/models/auth/auth_response.dart';
import 'package:widyu/core/data/repositories/auth/auth_repository.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDatasource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDatasource,
    required TokenManager tokenManager,
  })  : _remoteDatasource = remoteDatasource,
        _tokenManager = tokenManager;

  @override
  Future<ApiResult<void>> login(String inviteCode, String phoneNumber) async {
    final result =
        await _remoteDatasource.login(inviteCode, phoneNumber).toApiResult();
    if (result is Success) {
      final data = (result as Success<AuthResponse>).data;
      await _tokenManager.setMemberId(data.memberId);
      await _tokenManager.setToken(data.accessToken, data.refreshToken);
    }
    return result;
  }

  @override
  Future<ApiResult<void>> logout() async {
    final result = await _remoteDatasource.logout().toApiResult();
    if (result is Success) {
      await _tokenManager.removeToken();
    }
    return result;
  }
}
