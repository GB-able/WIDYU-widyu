import 'package:widyu/core/model/sensor/sensor_batch.dart';

abstract class SensorBatchRemoteDataSource {
  bool sendBatch(SensorBatch batch);

  Future<bool> resendBatches(List<SensorBatch> batches);

  bool sendDropped(SensorDroppedRecord record);

  Stream<bool> get connectionState;
}
