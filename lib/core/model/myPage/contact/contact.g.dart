// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
      representative: Representative.fromJson(
          json['representative'] as Map<String, dynamic>),
      familyMembers: (json['familyMembers'] as List<dynamic>)
          .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
      'representative': instance.representative,
      'familyMembers': instance.familyMembers,
    };
