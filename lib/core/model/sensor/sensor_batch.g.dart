// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorBatch _$SensorBatchFromJson(Map<String, dynamic> json) => _SensorBatch(
      v: (json['v'] as num?)?.toInt() ?? 2,
      stream: json['stream'] as String? ?? 'imu_watch',
      source: json['source'] as String? ?? 'watch',
      batchId: json['batch_id'] as String,
      deviceId: json['device_id'] as String,
      sessionId: json['session_id'] as String,
      seq: (json['seq'] as num).toInt(),
      studyId: json['study_id'] as String?,
      participationId: json['participation_id'] as String?,
      runId: json['run_id'] as String?,
      clock: ClockInfo.fromJson(json['clock'] as Map<String, dynamic>),
      acc: json['acc'] == null
          ? null
          : AccSeries.fromJson(json['acc'] as Map<String, dynamic>),
      gyro: json['gyro'] == null
          ? null
          : GyroSeries.fromJson(json['gyro'] as Map<String, dynamic>),
      trigger: json['trigger'] == null
          ? null
          : ImpactTrigger.fromJson(json['trigger'] as Map<String, dynamic>),
      gyroBackfill: json['gyro_backfill'] as bool? ?? false,
      backfillFor: json['backfill_for'] as String?,
      resend: json['resend'] == null
          ? null
          : ResendInfo.fromJson(json['resend'] as Map<String, dynamic>),
      collectionMode: json['collection_mode'] as String,
      gyroMode: json['gyro_mode'] as String,
      onBody: json['on_body'] as bool?,
      wearState: json['wear_state'] as String?,
      missingReason: json['missing_reason'] as String?,
      watchBatteryPct: (json['watch_battery_pct'] as num?)?.toInt(),
      phoneReceivedAtMs: (json['phone_received_at_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SensorBatchToJson(_SensorBatch instance) =>
    <String, dynamic>{
      'v': instance.v,
      'stream': instance.stream,
      'source': instance.source,
      'batch_id': instance.batchId,
      'device_id': instance.deviceId,
      'session_id': instance.sessionId,
      'seq': instance.seq,
      'study_id': instance.studyId,
      'participation_id': instance.participationId,
      'run_id': instance.runId,
      'clock': nestedToJson(instance.clock),
      'acc': nestedToJson(instance.acc),
      'gyro': nestedToJson(instance.gyro),
      'trigger': nestedToJson(instance.trigger),
      'gyro_backfill': instance.gyroBackfill,
      'backfill_for': instance.backfillFor,
      'resend': nestedToJson(instance.resend),
      'collection_mode': instance.collectionMode,
      'gyro_mode': instance.gyroMode,
      'on_body': instance.onBody,
      'wear_state': instance.wearState,
      'missing_reason': instance.missingReason,
      'watch_battery_pct': instance.watchBatteryPct,
      'phone_received_at_ms': instance.phoneReceivedAtMs,
    };

_AccSeries _$AccSeriesFromJson(Map<String, dynamic> json) => _AccSeries(
      fsHzRequested: (json['fs_hz_requested'] as num).toInt(),
      n: (json['n'] as num).toInt(),
      t0ElapsedNs: json['t0_elapsed_ns'] as String,
      dtNs: (json['dt_ns'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      mg: (json['mg'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
    );

Map<String, dynamic> _$AccSeriesToJson(_AccSeries instance) =>
    <String, dynamic>{
      'fs_hz_requested': instance.fsHzRequested,
      'n': instance.n,
      't0_elapsed_ns': instance.t0ElapsedNs,
      'dt_ns': instance.dtNs,
      'mg': instance.mg,
    };

_GyroSeries _$GyroSeriesFromJson(Map<String, dynamic> json) => _GyroSeries(
      fsHzRequested: (json['fs_hz_requested'] as num).toInt(),
      n: (json['n'] as num).toInt(),
      t0ElapsedNs: json['t0_elapsed_ns'] as String,
      dtNs: (json['dt_ns'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      mrads: (json['mrads'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
    );

Map<String, dynamic> _$GyroSeriesToJson(_GyroSeries instance) =>
    <String, dynamic>{
      'fs_hz_requested': instance.fsHzRequested,
      'n': instance.n,
      't0_elapsed_ns': instance.t0ElapsedNs,
      'dt_ns': instance.dtNs,
      'mrads': instance.mrads,
    };

_ImpactTrigger _$ImpactTriggerFromJson(Map<String, dynamic> json) =>
    _ImpactTrigger(
      kind: json['kind'] as String,
      smvG: (json['smv_g'] as num).toDouble(),
      eventElapsedNs: json['event_elapsed_ns'] as String,
      tsMs: (json['ts_ms'] as num).toInt(),
    );

Map<String, dynamic> _$ImpactTriggerToJson(_ImpactTrigger instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'smv_g': instance.smvG,
      'event_elapsed_ns': instance.eventElapsedNs,
      'ts_ms': instance.tsMs,
    };

_ClockInfo _$ClockInfoFromJson(Map<String, dynamic> json) => _ClockInfo(
      bootId: json['boot_id'] as String,
      clockMappingId: json['clock_mapping_id'] as String,
      anchorElapsedNs: json['anchor_elapsed_ns'] as String,
      anchorEpochMs: (json['anchor_epoch_ms'] as num).toInt(),
      uncertaintyMs: (json['uncertainty_ms'] as num).toDouble(),
    );

Map<String, dynamic> _$ClockInfoToJson(_ClockInfo instance) =>
    <String, dynamic>{
      'boot_id': instance.bootId,
      'clock_mapping_id': instance.clockMappingId,
      'anchor_elapsed_ns': instance.anchorElapsedNs,
      'anchor_epoch_ms': instance.anchorEpochMs,
      'uncertainty_ms': instance.uncertaintyMs,
    };

_ResendInfo _$ResendInfoFromJson(Map<String, dynamic> json) => _ResendInfo(
      isResend: json['is_resend'] as bool,
      originalBatchId: json['original_batch_id'] as String,
      originalSeq: (json['original_seq'] as num).toInt(),
      originalRunId: json['original_run_id'] as String?,
      originalSessionId: json['original_session_id'] as String,
      resentAtMs: (json['resent_at_ms'] as num).toInt(),
    );

Map<String, dynamic> _$ResendInfoToJson(_ResendInfo instance) =>
    <String, dynamic>{
      'is_resend': instance.isResend,
      'original_batch_id': instance.originalBatchId,
      'original_seq': instance.originalSeq,
      'original_run_id': instance.originalRunId,
      'original_session_id': instance.originalSessionId,
      'resent_at_ms': instance.resentAtMs,
    };
