import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';

abstract class HeartRateRepository {
  void observeHeartRate();

  void stopObserveHeartRate();

  Future<ApiResult<HeartRateResponse>> fetchHeartRate();
}
