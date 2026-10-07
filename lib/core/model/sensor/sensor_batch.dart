// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_batch.freezed.dart';
part 'sensor_batch.g.dart';

@freezed
abstract class ClockInfo with _$ClockInfo {
  const factory ClockInfo({
    @JsonKey(name: 'boot_id') required String bootId,
    @JsonKey(name: 'clock_mapping_id') required String clockMappingId,
    @JsonKey(name: 'anchor_elapsed_ns') required String anchorElapsedNs,
    @JsonKey(name: 'anchor_epoch_ms') required int anchorEpochMs,
    @JsonKey(name: 'uncertainty_ms') required double uncertaintyMs,
  }) = _ClockInfo;

  factory ClockInfo.fromJson(Map<String, dynamic> json) =>
      _$ClockInfoFromJson(json);
}

@freezed
abstract class AccSeries with _$AccSeries {
  const factory AccSeries({
    @JsonKey(name: 'fs_hz_requested') required int fsHzRequested,
    required int n,
    @JsonKey(name: 't0_elapsed_ns') required String t0ElapsedNs,
    @JsonKey(name: 'dt_ns') required List<int> dtNs,
    required List<List<int>> mg,
  }) = _AccSeries;

  factory AccSeries.fromJson(Map<String, dynamic> json) =>
      _$AccSeriesFromJson(json);
}

@freezed
abstract class GyroSeries with _$GyroSeries {
  const factory GyroSeries({
    @JsonKey(name: 'fs_hz_requested') required int fsHzRequested,
    required int n,
    @JsonKey(name: 't0_elapsed_ns') required String t0ElapsedNs,
    @JsonKey(name: 'dt_ns') required List<int> dtNs,
    required List<List<int>> mrads,
  }) = _GyroSeries;

  factory GyroSeries.fromJson(Map<String, dynamic> json) =>
      _$GyroSeriesFromJson(json);
}

@freezed
abstract class ImpactTrigger with _$ImpactTrigger {
  const factory ImpactTrigger({
    required String kind,
    @JsonKey(name: 'smv_g') required double smvG,
    @JsonKey(name: 'event_elapsed_ns') required String eventElapsedNs,
    @JsonKey(name: 'ts_ms') required int tsMs,
  }) = _ImpactTrigger;

  factory ImpactTrigger.fromJson(Map<String, dynamic> json) =>
      _$ImpactTriggerFromJson(json);
}

@freezed
abstract class ResendInfo with _$ResendInfo {
  const factory ResendInfo({
    @JsonKey(name: 'is_resend') required bool isResend,
    @JsonKey(name: 'original_batch_id') required String originalBatchId,
    @JsonKey(name: 'original_seq') required int originalSeq,
    @JsonKey(name: 'original_run_id') required String? originalRunId,
    @JsonKey(name: 'original_session_id') required String originalSessionId,
    @JsonKey(name: 'resent_at_ms') required int resentAtMs,
  }) = _ResendInfo;

  factory ResendInfo.fromJson(Map<String, dynamic> json) =>
      _$ResendInfoFromJson(json);
}

@freezed
abstract class SensorBatch with _$SensorBatch {
  const factory SensorBatch({
    @Default(2) int v,
    @Default('imu_watch') String stream,
    @Default('watch') String source,
    @JsonKey(name: 'batch_id') required String batchId,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'session_id') required String sessionId,
    required int seq,
    @JsonKey(name: 'study_id') String? studyId,
    @JsonKey(name: 'participation_id') String? participationId,
    @JsonKey(name: 'run_id') String? runId,
    @JsonKey(toJson: _nestedToJson) required ClockInfo clock,
    @JsonKey(toJson: _nestedToJson) AccSeries? acc,
    @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
    @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
    @JsonKey(name: 'gyro_backfill') @Default(false) bool gyroBackfill,
    @JsonKey(name: 'backfill_for') String? backfillFor,
    @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
    @JsonKey(name: 'collection_mode') required String collectionMode,
    @JsonKey(name: 'gyro_mode') required String gyroMode,
    @JsonKey(name: 'on_body') bool? onBody,
    @JsonKey(name: 'wear_state') String? wearState,
    @JsonKey(name: 'missing_reason') String? missingReason,
    @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
    @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
  }) = _SensorBatch;

  factory SensorBatch.fromJson(Map<String, dynamic> json) =>
      _$SensorBatchFromJson(json);
}

@freezed
abstract class SensorDroppedRecord with _$SensorDroppedRecord {
  const factory SensorDroppedRecord({
    @Default('imu_dropped') String stream,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'from_seq') required int fromSeq,
    @JsonKey(name: 'to_seq') required int toSeq,
    required String reason,
    @JsonKey(name: 'ts_ms') required int tsMs,
  }) = _SensorDroppedRecord;

  factory SensorDroppedRecord.fromJson(Map<String, dynamic> json) =>
      _$SensorDroppedRecordFromJson(json);
}

/// 로컬 EventChannel 이 두 종류를 한 스트림으로 흘리므로 `stream` 값으로 가른다.
@freezed
sealed class SensorMessage with _$SensorMessage {
  const factory SensorMessage.batch(SensorBatch batch) = SensorMessageBatch;

  const factory SensorMessage.dropped(SensorDroppedRecord record) =
      SensorMessageDropped;

  /// freezed 의 runtimeType 기반 union JSON 대신 `stream` 값으로 분기하므로 static 이다.
  static SensorMessage fromJson(Map<String, dynamic> json) =>
      json['stream'] == 'imu_dropped'
          ? SensorMessage.dropped(SensorDroppedRecord.fromJson(json))
          : SensorMessage.batch(SensorBatch.fromJson(json));
}

/// `explicitToJson` 대체 — 클래스 단위 `@JsonSerializable` 은 freezed 추상 클래스에서 생성이 실패한다.
Map<String, dynamic>? _nestedToJson(dynamic value) =>
    value?.toJson() as Map<String, dynamic>?;
