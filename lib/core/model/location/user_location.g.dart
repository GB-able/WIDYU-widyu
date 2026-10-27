// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLocation _$UserLocationFromJson(Map<String, dynamic> json) =>
    _UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      measuredAt: (json['measuredAt'] as num?)?.toInt(),
      accuracyM: (json['accuracyM'] as num?)?.toDouble(),
      speedMps: (json['speedMps'] as num?)?.toDouble(),
      speedAccuracyMps: (json['speedAccuracyMps'] as num?)?.toDouble(),
      headingDeg: (json['headingDeg'] as num?)?.toDouble(),
      altitudeM: (json['altitudeM'] as num?)?.toDouble(),
      isMock: json['isMock'] as bool? ?? false,
    );

Map<String, dynamic> _$UserLocationToJson(_UserLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'measuredAt': instance.measuredAt,
      'accuracyM': instance.accuracyM,
      'speedMps': instance.speedMps,
      'speedAccuracyMps': instance.speedAccuracyMps,
      'headingDeg': instance.headingDeg,
      'altitudeM': instance.altitudeM,
      'isMock': instance.isMock,
    };
