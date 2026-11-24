import 'package:widyu/core/model/sensor/sensor_config.dart';

abstract class SensorConfigRepository {
  /// 조회에 성공할 때마다 내는 설정. 실패한 주기는 내지 않는다.
  Stream<SensorConfig> get configs;

  /// 즉시 설정을 조회해 워치로 내리고, 서버가 알려 준 간격마다 반복한다.
  void start();

  void stop();
}
