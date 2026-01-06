import 'package:widyu/core/data/models/api_response.dart';
import 'package:widyu/core/data/models/token_pair.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;
  final String path = '/auth';

  Future<ApiResponse<TokenPair>> login(
      String inviteCode, String phoneNumber) async {
    try {
      final response = await _apiClient.req(
        path: '$path/seniors/sign-in',
        method: HttpMethod.post,
        body: {
          'inviteCode': inviteCode,
          'phoneNumber': phoneNumber,
        },
      );
      return response.toApiResponse(TokenPair.fromJson);
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiClient.req(
        path: '$path/logout',
        method: HttpMethod.post,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }
}
