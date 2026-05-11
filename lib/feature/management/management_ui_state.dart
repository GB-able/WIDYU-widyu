import 'package:freezed_annotation/freezed_annotation.dart';

part 'management_ui_state.freezed.dart';

@freezed
abstract class ManagementUiState with _$ManagementUiState {
  const factory ManagementUiState({
    @Default(true) bool isLoading,
    @Default('') String familyCode,
  }) = _ManagementUiState;
}
