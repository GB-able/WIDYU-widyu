abstract class AuthLocalDataSource {
  Future<void> saveAuthentication(
    int memberId,
    String accessToken,
    String refreshToken,
  );

  Future<void> removeAuthentication();

  /// 저장된 회원 식별자. 로그인 전이거나 값이 깨졌으면 null.
  Future<int?> getMemberId();
}
