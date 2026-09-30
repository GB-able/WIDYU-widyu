// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_batch.freezed.dart';
part 'sensor_batch.g.dart';

/// 워치 `ImuBatch.toMap()`(부록 A)이 만드는 JSON 그대로를 모델로 옮긴 것이다.
/// 키 이름·타입·null 규칙은 그 파일이 정본이므로 임의로 바꾸지 않는다.
/// 나노초 값은 JS 정수 범위를 넘으므로 10진 문자열로 싣는다(int 로 바꾸지 말 것).

/// 단조 시각(부팅 기준)을 벽시계로 환산하기 위한 기준점.
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

/// 가속도 묶음. 값 배열 키가 `mg` 라 [GyroSeries] 와 클래스를 나눈다.
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

/// 자이로 묶음. 값 배열 키가 `mrads` 라 [AccSeries] 와 클래스를 나눈다.
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

/// 충격 표시. 낙상 판정이 아니라 「이 구간 자이로를 빠뜨리지 말라」는 신호다.
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

/// REST 재전송 시에만 붙는다. 원본 배치 필드는 건드리지 않는다.
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

/// IMU 배치 봉투(`stream == 'imu_watch'`).
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
    // 서버가 clock{} 을 펼치지 않고도 세대를 가릴 수 있도록 최상위에도 둔다.
    @JsonKey(name: 'boot_id') required String bootId,
    @JsonKey(name: 'clock_mapping_id') required String clockMappingId,
    @JsonKey(toJson: _nestedToJson) required ClockInfo clock,
    @JsonKey(toJson: _nestedToJson) AccSeries? acc,
    @JsonKey(toJson: _nestedToJson) GyroSeries? gyro,
    @JsonKey(toJson: _nestedToJson) ImpactTrigger? trigger,
    @JsonKey(name: 'gyro_backfill') @Default(false) bool gyroBackfill,
    @JsonKey(name: 'backfill_for') String? backfillFor,
    @JsonKey(name: 'gyro_mode') required String gyroMode,
    @JsonKey(name: 'collection_mode') required String collectionMode,
    @JsonKey(name: 'missing_reason') String? missingReason,
    @JsonKey(name: 'on_body') bool? onBody,
    @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
    @JsonKey(toJson: _nestedToJson) ResendInfo? resend,
  }) = _SensorBatch;

  factory SensorBatch.fromJson(Map<String, dynamic> json) =>
      _$SensorBatchFromJson(json);
}

/// 폰 네이티브가 넘기는 폐기 레코드(`stream == 'imu_dropped'`).
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

  /// factory 가 아닌 static — freezed 의 runtimeType 기반 union JSON 대신
  /// 워치/네이티브가 실제로 보내는 `stream` 값으로 분기한다.
  static SensorMessage fromJson(Map<String, dynamic> json) =>
      json['stream'] == 'imu_dropped'
          ? SensorMessage.dropped(SensorDroppedRecord.fromJson(json))
          : SensorMessage.batch(SensorBatch.fromJson(json));
}

/// json_serializable 의 `explicitToJson` 대체. 클래스 단위 `@JsonSerializable` 을
/// freezed 클래스에 붙이면 생성기가 추상 클래스를 대상으로 삼아 실패한다.
Map<String, dynamic>? _nestedToJson(dynamic value) =>
    value?.toJson() as Map<String, dynamic>?;
