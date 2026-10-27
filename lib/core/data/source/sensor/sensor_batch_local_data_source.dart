import 'package:widyu/core/model/sensor/sensor_message.dart';

abstract class SensorBatchLocalDataSource {
  Stream<SensorMessage> getSensorBatches();

  /// 서버가 받은 항목을 워치 Data Layer 에서 지운다. 지우기 전까지는 재부팅해도 남아 다음 기동 때 다시 흘러온다.
  void consume({
    required String stream,
    required String sessionId,
    required int seq,
  });
}
