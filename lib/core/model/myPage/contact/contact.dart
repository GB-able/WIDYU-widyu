import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/myPage/contact/family_member.dart';
import 'package:widyu/core/model/myPage/contact/representative.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required Representative? representative,
    required List<FamilyMember> familyMembers,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
