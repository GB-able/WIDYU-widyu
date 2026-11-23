// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_health_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyHealthSchedule _$DailyHealthScheduleFromJson(Map<String, dynamic> json) =>
    _DailyHealthSchedule(
      healthScheduleId: (json['healthScheduleId'] as num).toInt(),
      scheduleName: json['scheduleName'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      placeAddress: json['placeAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      progressStatus:
          $enumDecode(_$HealthScheduleStateEnumMap, json['progressStatus']),
    );

Map<String, dynamic> _$DailyHealthScheduleToJson(
        _DailyHealthSchedule instance) =>
    <String, dynamic>{
      'healthScheduleId': instance.healthScheduleId,
      'scheduleName': instance.scheduleName,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'placeAddress': instance.placeAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'progressStatus': _$HealthScheduleStateEnumMap[instance.progressStatus]!,
    };

const _$HealthScheduleStateEnumMap = {
  HealthScheduleState.upcoming: 'UPCOMING',
  HealthScheduleState.incomplete: 'INCOMPLETE',
  HealthScheduleState.completed: 'COMPLETED',
};
