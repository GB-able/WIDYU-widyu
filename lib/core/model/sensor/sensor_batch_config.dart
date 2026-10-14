class SensorBatchConfig {
  const SensorBatchConfig._();

  static const queueMax = 1800;
  static const retryInterval = Duration(seconds: 30);

  /// STOMP 로 보낸 배치의 결과를 이 시간까지 못 받으면 REST 재전송 큐로 넘긴다.
  static const ackTimeout = Duration(seconds: 10);
}
