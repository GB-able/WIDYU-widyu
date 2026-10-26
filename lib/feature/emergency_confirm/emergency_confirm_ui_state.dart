import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_confirm_ui_state.freezed.dart';

enum EmergencyConfirmPhase { confirm, okay, notOkay }

@freezed
abstract class EmergencyConfirmUiState with _$EmergencyConfirmUiState {
  const factory EmergencyConfirmUiState({
    @Default(EmergencyConfirmPhase.confirm) EmergencyConfirmPhase phase,
    @Default(false) bool isSubmitting,
  }) = _EmergencyConfirmUiState;
}
