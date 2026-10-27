import 'package:widyu/core/data/source/auth/auth_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/auth/auth_response.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;
  final String path = '/auth';

  @override
  Future<ApiResponse<AuthResponse>> login(
    String inviteCode,
    String phoneNumber,
  ) async {
    try {
      final response = await _apiClient.req(
        path: '$path/seniors/sign-in',
        method: HttpMethod.post,
        body: {
          'inviteCode': inviteCode,
          'phoneNumber': phoneNumber,
        },
      );
      return response.toApiResponse(AuthResponse.fromJson);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiClient.req(
        path: '$path/logout',
        method: HttpMethod.post,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<ApiResponse<String>> fetchSocketToken() async {
    try {
      final response = await _apiClient.req(
        path: '/ws/token',
        method: HttpMethod.post,
      );
      return ApiResponse<String>(
        statusCode: response.statusCode,
        code: response.data['code'] as String,
        message: response.data['message'] as String,
        data: response.data['data'] as String?,
      );
    } catch (e) {
      throw Exception('소켓 토큰 발급에 실패했습니다: $e');
    }
  }
}
