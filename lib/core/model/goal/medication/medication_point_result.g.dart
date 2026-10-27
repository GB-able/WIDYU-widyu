// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_point_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicationPointResult _$MedicationPointResultFromJson(
        Map<String, dynamic> json) =>
    _MedicationPointResult(
      currentPoints: (json['currentPoints'] as num?)?.toInt() ?? 0,
      earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MedicationPointResultToJson(
        _MedicationPointResult instance) =>
    <String, dynamic>{
      'currentPoints': instance.currentPoints,
      'earnedPoints': instance.earnedPoints,
    };
