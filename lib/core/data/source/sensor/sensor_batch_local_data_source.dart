import 'package:widyu/core/model/sensor/sensor_message.dart';

abstract class SensorBatchLocalDataSource {
  Stream<SensorMessage> getSensorBatches();
}
