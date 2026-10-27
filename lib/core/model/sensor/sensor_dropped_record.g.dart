// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_dropped_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorDroppedRecord _$SensorDroppedRecordFromJson(Map<String, dynamic> json) =>
    _SensorDroppedRecord(
      stream: json['stream'] as String? ?? 'imu_dropped',
      sessionId: json['session_id'] as String,
      fromSeq: (json['from_seq'] as num).toInt(),
      toSeq: (json['to_seq'] as num).toInt(),
      reason: json['reason'] as String,
      tsMs: (json['ts_ms'] as num).toInt(),
    );

Map<String, dynamic> _$SensorDroppedRecordToJson(
        _SensorDroppedRecord instance) =>
    <String, dynamic>{
      'stream': instance.stream,
      'session_id': instance.sessionId,
      'from_seq': instance.fromSeq,
      'to_seq': instance.toSeq,
      'reason': instance.reason,
      'ts_ms': instance.tsMs,
    };
