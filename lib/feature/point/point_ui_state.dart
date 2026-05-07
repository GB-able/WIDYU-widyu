import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/feature/point/point_ui_model.dart';

part 'point_ui_state.freezed.dart';

@freezed
abstract class PointUiState with _$PointUiState {
  const factory PointUiState({
    @Default(false) bool isLoading,
    @Default(0) int currentPoints,
    @Default([]) List<PointUiModel> histories,
  }) = _PointUiState;
}
