class SensorBatchConfig {
  const SensorBatchConfig._();

  /// 워치 Data Layer 상한(IMU 30분 1800개 + 심박 720개)을 다 받아도 앞쪽이 밀려나지 않게 맞춘다.
  static const queueMax = 1800 + 720;
  static const retryInterval = Duration(seconds: 30);

  /// STOMP 로 보낸 배치의 결과를 이 시간까지 못 받으면 REST 재전송 큐로 넘긴다.
  static const ackTimeout = Duration(seconds: 10);
}
