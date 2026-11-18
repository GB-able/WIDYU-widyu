abstract class HeartbeatRepository {
  /// 연구 모드인 동안 폰·워치 상태를 주기마다 서버로 보낸다.
  void start();

  void stop();
}
