// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalkDaily _$WalkDailyFromJson(Map<String, dynamic> json) => _WalkDaily(
      date: DateTime.parse(json['date'] as String),
      goal: (json['goal'] as num?)?.toInt(),
      actual: (json['actual'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalkDailyToJson(_WalkDaily instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'goal': instance.goal,
      'actual': instance.actual,
    };
