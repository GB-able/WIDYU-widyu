import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_check_ui_state.freezed.dart';

enum SafetyCheckPhase { confirm, okay, notOkay }

@freezed
abstract class SafetyCheckUiState with _$SafetyCheckUiState {
  const factory SafetyCheckUiState({
    @Default(SafetyCheckPhase.confirm) SafetyCheckPhase phase,
    @Default(false) bool isSubmitting,
  }) = _SafetyCheckUiState;
}
