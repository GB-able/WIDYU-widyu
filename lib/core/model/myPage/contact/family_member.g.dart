// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) =>
    _FamilyMember(
      memberId: (json['memberId'] as num).toInt(),
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      isRepresentative: json['isRepresentative'] as bool,
    );

Map<String, dynamic> _$FamilyMemberToJson(_FamilyMember instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'isRepresentative': instance.isRepresentative,
    };
