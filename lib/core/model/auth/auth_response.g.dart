// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) =>
    _AuthResponse(
      memberId: (json['memberId'] as num).toInt(),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(_AuthResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
