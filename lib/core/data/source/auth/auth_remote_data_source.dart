import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/auth/auth_response.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<AuthResponse>> login(
    String inviteCode,
    String phoneNumber,
  );

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<String>> fetchSocketToken();
}
