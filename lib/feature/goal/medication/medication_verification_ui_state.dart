import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication_verification_ui_state.freezed.dart';

@freezed
abstract class MedicationVerificationUiState
    with _$MedicationVerificationUiState {
  const factory MedicationVerificationUiState({
    @Default(false) bool isReady,
    @Default(false) bool isBusy,
    @Default(false) bool isPermissionDenied,
    File? photo,
  }) = _MedicationVerificationUiState;
}
