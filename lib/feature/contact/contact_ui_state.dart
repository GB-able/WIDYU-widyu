import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/myPage/contact/family_member.dart';
import 'package:widyu/core/model/myPage/contact/representative.dart';

part 'contact_ui_state.freezed.dart';

@freezed
abstract class ContactUiState with _$ContactUiState {
  const factory ContactUiState({
    @Default(false) bool isLoading,
    @Default(null) Representative? representative,
    @Default([]) List<FamilyMember> familyMembers,
  }) = _ContactUiState;
}
