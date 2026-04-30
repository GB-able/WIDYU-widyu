// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      memberId: (json['memberId'] as num).toInt(),
      profileImage: json['profileImage'] as String?,
      name: json['name'] as String,
      points: (json['points'] as num).toInt(),
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'memberId': instance.memberId,
      'profileImage': instance.profileImage,
      'name': instance.name,
      'points': instance.points,
    };
