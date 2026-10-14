import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_verification.freezed.dart';
part 'medication_verification.g.dart';

@freezed
abstract class MedicationVerification with _$MedicationVerification {
  const factory MedicationVerification({
    required int earnedPoints,
    required int currentPoints,
  }) = _MedicationVerification;

  factory MedicationVerification.fromJson(Map<String, dynamic> json) =>
      _$MedicationVerificationFromJson(json);
}
