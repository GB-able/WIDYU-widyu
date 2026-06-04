import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_member.freezed.dart';
part 'family_member.g.dart';

@freezed
abstract class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required int memberId,
    required String name,
    required String phoneNumber,
    required bool isRepresentative,
  }) = _FamilyMember;

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);
}
