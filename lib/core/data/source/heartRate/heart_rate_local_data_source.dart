import 'package:widyu/core/model/heartRate/heart_rate.dart';

abstract class HeartRateLocalDataSource {
  Stream<HeartRate> getHeartRates();

  Future<void> sendHeartRateStatus(String heartRateStatus);
}
