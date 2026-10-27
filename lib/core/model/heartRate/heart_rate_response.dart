import 'package:freezed_annotation/freezed_annotation.dart';

part 'heart_rate_response.freezed.dart';
part 'heart_rate_response.g.dart';

@freezed
abstract class HeartRateResponse with _$HeartRateResponse {
  const factory HeartRateResponse({
    required int memberId,
    required String heartRateStatus,
    /// 아직 판정된 심박이 없으면(상태 UNKNOWN) 서버가 null 로 준다.
    int? heartRate,
    DateTime? measuredAt,
  }) = _HeartRateResponse;

  factory HeartRateResponse.fromJson(Map<String, dynamic> json) =>
      _$HeartRateResponseFromJson(json);
}
