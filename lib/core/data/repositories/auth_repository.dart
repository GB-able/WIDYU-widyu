import 'package:widyu/core/data/datasources/auth_remote_datasource.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/network/api_client.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final ApiClient _apiClient = ApiClient();

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

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
