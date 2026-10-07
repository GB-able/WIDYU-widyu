abstract class SensorConfigRepository {
  /// 즉시 설정을 조회해 워치로 내리고, 서버가 알려 준 간격마다 반복한다.
  void start();

  void stop();
}
