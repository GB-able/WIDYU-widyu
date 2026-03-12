// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRate _$HeartRateFromJson(Map<String, dynamic> json) => _HeartRate(
      heartRate: (json['heartRate'] as num).toInt(),
      measuredAt: DateTime.parse(json['measuredAt'] as String),
    );

Map<String, dynamic> _$HeartRateToJson(_HeartRate instance) =>
    <String, dynamic>{
      'heartRate': instance.heartRate,
      'measuredAt': instance.measuredAt.toIso8601String(),
    };
