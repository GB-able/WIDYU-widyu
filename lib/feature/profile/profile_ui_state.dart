import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_ui_state.freezed.dart';

@freezed
abstract class ProfileUiState with _$ProfileUiState {
  const factory ProfileUiState({
    @Default(false) bool isLoading,
    @Default('') String name,
    @Default(null) String? profileImage,
    @Default('') String phoneNumber,
    @Default('') String address,
    @Default('') String detailAddress,
    @Default('') String inviteCode,
  }) = _ProfileUiState;
}
