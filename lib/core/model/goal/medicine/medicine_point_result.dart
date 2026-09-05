import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine_point_result.freezed.dart';
part 'medicine_point_result.g.dart';

@freezed
abstract class MedicinePointResult with _$MedicinePointResult {
  const factory MedicinePointResult({
    @Default(0) int currentPoints,
    @Default(0) int earnedPoints,
  }) = _MedicinePointResult;

  factory MedicinePointResult.fromJson(Map<String, dynamic> json) =>
      _$MedicinePointResultFromJson(json);
}
