import 'package:freezed_annotation/freezed_annotation.dart';

part 'heart_rate.freezed.dart';
part 'heart_rate.g.dart';

@freezed
abstract class HeartRate with _$HeartRate {
  const factory HeartRate({
    required int heartRate,
    required DateTime measuredAt,
  }) = _HeartRate;

  factory HeartRate.fromJson(Map<String, dynamic> json) => _$HeartRateFromJson(json);
}
