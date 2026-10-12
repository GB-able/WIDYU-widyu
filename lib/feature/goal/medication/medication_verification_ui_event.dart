import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

sealed class MedicationVerificationUiEvent {
  const MedicationVerificationUiEvent();
}

class OccurrenceNotFound extends MedicationVerificationUiEvent {
  const OccurrenceNotFound();
}

class VerifySuccess extends MedicationVerificationUiEvent {
  const VerifySuccess(this.result);

  final MedicationPointResult result;
}

class VerifyFailure extends MedicationVerificationUiEvent {
  const VerifyFailure();
}
