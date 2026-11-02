// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalkDetail _$WalkDetailFromJson(Map<String, dynamic> json) => _WalkDetail(
      goal: (json['goal'] as num).toInt(),
      actual: (json['actual'] as num).toInt(),
    );

Map<String, dynamic> _$WalkDetailToJson(_WalkDetail instance) =>
    <String, dynamic>{
      'goal': instance.goal,
      'actual': instance.actual,
    };
