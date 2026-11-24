abstract class DeviceEventRepository {
  /// 워치가 넘긴 상태 이벤트를 모아 주기마다 서버로 올린다.
  void start();

  void stop();
}
