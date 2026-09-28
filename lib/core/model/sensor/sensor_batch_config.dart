class SensorBatchConfig {
  const SensorBatchConfig._();

  static const queueMax = 1800;
  static const retryInterval = Duration(seconds: 30);
}
