// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorResult _$SensorResultFromJson(Map<String, dynamic> json) =>
    _SensorResult(
      batchId: json['batchId'] as String,
      seq: (json['seq'] as num).toInt(),
      result: json['result'] as String,
    );

Map<String, dynamic> _$SensorResultToJson(_SensorResult instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'seq': instance.seq,
      'result': instance.result,
    };
