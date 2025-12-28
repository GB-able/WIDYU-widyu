import 'package:widyu/core/data/datasources/auth_remote_datasource.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/network/api_client.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final ApiClient _apiClient;

  AuthRepository({
    required AuthRemoteDatasource remoteDatasource,
    required ApiClient apiClient,
  })  : _remoteDatasource = remoteDatasource,
        _apiClient = apiClient;

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
}
