import 'package:freezed_annotation/freezed_annotation.dart';

part 'heart_rate_response.freezed.dart';
part 'heart_rate_response.g.dart';

@freezed
abstract class HeartRateResponse with _$HeartRateResponse {
  const factory HeartRateResponse({
    required int memberId,
    required String heartRateStatus,
    required int heartRate,
    required DateTime measuredAt,
  }) = _HeartRateResponse;

  factory HeartRateResponse.fromJson(Map<String, dynamic> json) =>
      _$HeartRateResponseFromJson(json);
}
