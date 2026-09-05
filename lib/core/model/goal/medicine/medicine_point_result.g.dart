// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_point_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicinePointResult _$MedicinePointResultFromJson(Map<String, dynamic> json) =>
    _MedicinePointResult(
      currentPoints: (json['currentPoints'] as num?)?.toInt() ?? 0,
      earnedPoints: (json['earnedPoints'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MedicinePointResultToJson(
        _MedicinePointResult instance) =>
    <String, dynamic>{
      'currentPoints': instance.currentPoints,
      'earnedPoints': instance.earnedPoints,
    };
