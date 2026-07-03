// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      profileImage: json['profileImage'] as String?,
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'profileImage': instance.profileImage,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'inviteCode': instance.inviteCode,
    };
