abstract class SensorBatchRemoteDataSource {
  bool sendBatch(Map<String, dynamic> batch);

  Future<bool> resendBatches(List<Map<String, dynamic>> batches);

  Stream<bool> get connectionState;
}
