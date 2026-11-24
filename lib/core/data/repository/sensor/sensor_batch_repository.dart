abstract class SensorBatchRepository {
  void observeSensorBatches();

  void stopObserveSensorBatches();

  int get queueDepth;
}
