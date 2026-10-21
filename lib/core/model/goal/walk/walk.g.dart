// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Walk _$WalkFromJson(Map<String, dynamic> json) => _Walk(
      goal: (json['goal'] as num).toInt(),
      actual: (json['steps'] as num).toInt(),
      isReward: json['isReward'] as bool?,
    );

Map<String, dynamic> _$WalkToJson(_Walk instance) => <String, dynamic>{
      'goal': instance.goal,
      'steps': instance.actual,
      'isReward': instance.isReward,
    };
