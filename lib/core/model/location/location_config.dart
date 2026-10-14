class LocationConfig {
  const LocationConfig._();

  /// 정지 중 위치를 보내는 주기(스펙 §3-2).
  static const keepaliveInterval = Duration(seconds: 60);

  /// 재전송 대기열 상한. keepalive 주기로 12시간 분량.
  static const queueMax = 720;
}
