// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GoalHomeResponse _$GoalHomeResponseFromJson(Map<String, dynamic> json) =>
    _GoalHomeResponse(
      medicine: json['medicine'] == null
          ? null
          : Medication.fromJson(json['medicine'] as Map<String, dynamic>),
      walk: json['steps'] == null
          ? null
          : Walk.fromJson(json['steps'] as Map<String, dynamic>),
      hospital: json['hospital'] == null
          ? null
          : Hospital.fromJson(json['hospital'] as Map<String, dynamic>),
      todaySchedules: (json['todaySchedules'] as List<dynamic>?)
              ?.map((e) =>
                  DailyHealthSchedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GoalHomeResponseToJson(_GoalHomeResponse instance) =>
    <String, dynamic>{
      'medicine': instance.medicine,
      'steps': instance.walk,
      'hospital': instance.hospital,
      'todaySchedules': instance.todaySchedules,
    };
