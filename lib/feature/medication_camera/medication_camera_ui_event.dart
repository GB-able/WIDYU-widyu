import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

sealed class MedicationCameraUiEvent {
  const MedicationCameraUiEvent();
}

class OccurrenceNotFound extends MedicationCameraUiEvent {
  const OccurrenceNotFound();
}

class VerifySuccess extends MedicationCameraUiEvent {
  const VerifySuccess(this.result);

  final MedicationPointResult result;
}

class VerifyFailure extends MedicationCameraUiEvent {
  const VerifyFailure();
}
