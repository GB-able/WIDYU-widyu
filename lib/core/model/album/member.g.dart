// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
      id: (json['memberId'] as num).toInt(),
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
      'memberId': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
    };
