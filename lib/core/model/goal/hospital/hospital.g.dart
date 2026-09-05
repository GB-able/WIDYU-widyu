// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hospital _$HospitalFromJson(Map<String, dynamic> json) => _Hospital(
      hospitalScheduleId: (json['hospitalScheduleId'] as num).toInt(),
      dday: (json['dday'] as num).toInt(),
      datetime: DateTime.parse(json['datetime'] as String),
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isReward: json['isReward'] as bool?,
    );

Map<String, dynamic> _$HospitalToJson(_Hospital instance) => <String, dynamic>{
      'hospitalScheduleId': instance.hospitalScheduleId,
      'dday': instance.dday,
      'datetime': instance.datetime.toIso8601String(),
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isReward': instance.isReward,
    };
