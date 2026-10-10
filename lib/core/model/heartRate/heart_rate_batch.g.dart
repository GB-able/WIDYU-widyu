// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRateBatch _$HeartRateBatchFromJson(Map<String, dynamic> json) =>
    _HeartRateBatch(
      v: (json['v'] as num?)?.toInt() ?? 2,
      stream: json['stream'] as String? ?? 'hr',
      batchId: json['batch_id'] as String,
      deviceId: json['device_id'] as String,
      sessionId: json['session_id'] as String,
      seq: (json['seq'] as num).toInt(),
      studyId: json['study_id'] as String?,
      participationId: json['participation_id'] as String?,
      runId: json['run_id'] as String?,
      clock: ClockInfo.fromJson(json['clock'] as Map<String, dynamic>),
      samples: (json['samples'] as List<dynamic>)
          .map((e) => HeartRateSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      onBody: json['on_body'] as bool,
      watchBatteryPct: (json['watch_battery_pct'] as num?)?.toInt(),
      phoneReceivedAtMs: (json['phone_received_at_ms'] as num?)?.toInt(),
      resend: json['resend'] == null
          ? null
          : ResendInfo.fromJson(json['resend'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HeartRateBatchToJson(_HeartRateBatch instance) =>
    <String, dynamic>{
      'v': instance.v,
      'stream': instance.stream,
      'batch_id': instance.batchId,
      'device_id': instance.deviceId,
      'session_id': instance.sessionId,
      'seq': instance.seq,
      'study_id': instance.studyId,
      'participation_id': instance.participationId,
      'run_id': instance.runId,
      'clock': nestedToJson(instance.clock),
      'samples': listToJson(instance.samples),
      'on_body': instance.onBody,
      'watch_battery_pct': instance.watchBatteryPct,
      'phone_received_at_ms': instance.phoneReceivedAtMs,
      'resend': nestedToJson(instance.resend),
    };

_HeartRateSample _$HeartRateSampleFromJson(Map<String, dynamic> json) =>
    _HeartRateSample(
      bpm: (json['bpm'] as num).toInt(),
      tsMs: (json['ts_ms'] as num).toInt(),
      accuracy: json['accuracy'] as String,
    );

Map<String, dynamic> _$HeartRateSampleToJson(_HeartRateSample instance) =>
    <String, dynamic>{
      'bpm': instance.bpm,
      'ts_ms': instance.tsMs,
      'accuracy': instance.accuracy,
    };
