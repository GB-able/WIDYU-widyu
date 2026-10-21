import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_camera_ui_state.freezed.dart';

@freezed
abstract class MedicationCameraUiState with _$MedicationCameraUiState {
  const factory MedicationCameraUiState({
    @Default(false) bool isReady,
    @Default(false) bool isBusy,
    @Default(false) bool isPermissionDenied,
  }) = _MedicationCameraUiState;
}
