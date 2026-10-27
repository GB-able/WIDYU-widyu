// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointHistory _$PointHistoryFromJson(Map<String, dynamic> json) =>
    _PointHistory(
      currentPoints: (json['currentPoints'] as num).toInt(),
      histories: (json['histories'] as List<dynamic>)
          .map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PointHistoryToJson(_PointHistory instance) =>
    <String, dynamic>{
      'currentPoints': instance.currentPoints,
      'histories': instance.histories,
    };
