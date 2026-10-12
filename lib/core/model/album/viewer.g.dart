// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Viewer _$ViewerFromJson(Map<String, dynamic> json) => _Viewer(
      id: (json['memberId'] as num?)?.toInt(),
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$ViewerToJson(_Viewer instance) => <String, dynamic>{
      'memberId': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
    };
