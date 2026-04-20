// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      profileImage: json['profileImage'] as String?,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'profileImage': instance.profileImage,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'detailAddress': instance.detailAddress,
      'inviteCode': instance.inviteCode,
    };
