import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';

part 'heart_rate_request.freezed.dart';
part 'heart_rate_request.g.dart';

@freezed
abstract class HeartRateRequest with _$HeartRateRequest {
  const factory HeartRateRequest({
    required List<HeartRate> heartRates,
  }) = _HeartRateRequest;

  factory HeartRateRequest.fromJson(Map<String, dynamic> json) =>
      _$HeartRateRequestFromJson(json);
}