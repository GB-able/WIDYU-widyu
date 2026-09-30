import 'package:widyu/core/model/sensor/sensor_batch.dart';

abstract class SensorBatchLocalDataSource {
  Stream<SensorMessage> getSensorBatches();
}
