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
    try {
      final response = await _remoteDatasource.login(inviteCode, phoneNumber);

      if (response.isSuccess) {
        await _apiClient.setToken(
          response.data!.accessToken,
          response.data!.refreshToken,
        );
        return const Success(null);
      } else {
        return Failure(response.message,
            statusCode: response.statusCode, code: response.code);
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ApiResult<void>> logout() async {
    try {
      final response = await _remoteDatasource.logout();
      if (response.isSuccess) {
        await _apiClient.removeToken();
        return const Success(null);
      } else {
        return Failure(response.message,
            statusCode: response.statusCode, code: response.code);
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
