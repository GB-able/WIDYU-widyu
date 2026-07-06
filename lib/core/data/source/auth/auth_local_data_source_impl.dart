import 'package:widyu/core/data/source/auth/auth_local_data_source.dart';
import 'package:widyu/core/network/token_manager.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenManager _tokenManager = TokenManager();

  @override
  Future<void> saveAuthentication(
    int memberId,
    String accessToken,
    String refreshToken,
  ) async {
    await _tokenManager.setMemberId(memberId);
    await _tokenManager.setToken(accessToken, refreshToken);
  }

  @override
  Future<void> removeAuthentication() async {
    await _tokenManager.removeToken();
  }
}
