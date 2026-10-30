import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_page_ui_state.freezed.dart';

@freezed
abstract class MyPageUiState with _$MyPageUiState {
  const factory MyPageUiState({
    @Default(false) bool isLoading,
    @Default(null) String? profileImage,
    @Default(null) String? name,
    int? point,
    @Default(false) bool isPointLoading,
  }) = _MyPageUiState;
}
