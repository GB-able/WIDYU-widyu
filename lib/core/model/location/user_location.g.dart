// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLocation _$UserLocationFromJson(Map<String, dynamic> json) =>
    _UserLocation(
      memberId: json['memberId'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      measuredAt: (json['measuredAt'] as num?)?.toInt(),
      accuracyM: (json['accuracyM'] as num?)?.toDouble(),
      speedMps: (json['speedMps'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserLocationToJson(_UserLocation instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'measuredAt': instance.measuredAt,
      'accuracyM': instance.accuracyM,
      'speedMps': instance.speedMps,
    };
