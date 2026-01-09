import 'package:widyu/core/data/datasources/auth_remote_datasource.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/data/models/token_pair.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenManager _tokenManager;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required TokenManager tokenManager,
  })  : _remoteDatasource = remoteDatasource,
        _tokenManager = tokenManager;

  Future<ApiResult<void>> login(String inviteCode, String phoneNumber) async {
    final result =
        await _remoteDatasource.login(inviteCode, phoneNumber).toApiResult();
    if (result is Success) {
      final data = (result as Success<TokenPair>).data;
      await _tokenManager.setToken(data.accessToken, data.refreshToken);
    }
    return result;
  }

  Future<ApiResult<void>> logout() async {
    final result = await _remoteDatasource.logout().toApiResult();
    if (result is Success) {
      await _tokenManager.removeToken();
    }
    return result;
  }
}
