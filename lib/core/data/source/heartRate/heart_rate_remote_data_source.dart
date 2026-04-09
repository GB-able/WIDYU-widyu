import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_request.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';

abstract class HeartRateRemoteDataSource {
  void sendHeartRates(HeartRateRequest heartRateRequest);

  Future<ApiResponse<HeartRateResponse>> fetchHeartRateStatus();
}
