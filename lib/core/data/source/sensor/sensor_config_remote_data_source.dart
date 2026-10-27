import 'package:widyu/core/model/sensor/sensor_config.dart';

abstract class SensorConfigRemoteDataSource {
  /// 수집 설정 조회. 실패하면 null(호출자가 기존 설정을 유지한다).
  Future<SensorConfig?> fetch();
}
