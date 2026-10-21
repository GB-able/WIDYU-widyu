import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_point_result.freezed.dart';
part 'medication_point_result.g.dart';

@freezed
abstract class MedicationPointResult with _$MedicationPointResult {
  const factory MedicationPointResult({
    @Default(0) int currentPoints,
    @Default(0) int earnedPoints,
  }) = _MedicationPointResult;

  factory MedicationPointResult.fromJson(Map<String, dynamic> json) =>
      _$MedicationPointResultFromJson(json);
}
