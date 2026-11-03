import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

sealed class MedicationCameraUiEvent {
  const MedicationCameraUiEvent();
}

class OccurrenceNotFound extends MedicationCameraUiEvent {
  const OccurrenceNotFound();
}

class VerifyWindowClosed extends MedicationCameraUiEvent {
  const VerifyWindowClosed();
}

class VerifySuccess extends MedicationCameraUiEvent {
  const VerifySuccess(this.result);

  final MedicationPointResult result;
}

class VerifyFailure extends MedicationCameraUiEvent {
  const VerifyFailure(this.reason);

  final String reason;
}
