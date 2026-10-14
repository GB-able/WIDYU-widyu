import 'package:widyu/core/model/sensor/sensor_config.dart';

abstract class SensorConfigLocalDataSource {
  /// 수집 설정을 워치로 내려보낸다.
  Future<void> sendToWatch(SensorConfig config);
}
