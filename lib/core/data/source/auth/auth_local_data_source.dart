abstract class AuthLocalDataSource {
  Future<void> saveAuthentication(
    int memberId,
    String accessToken,
    String refreshToken,
  );

  Future<void> removeAuthentication();
}
