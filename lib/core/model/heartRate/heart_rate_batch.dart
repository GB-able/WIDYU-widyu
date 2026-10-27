// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';

part 'heart_rate_batch.freezed.dart';
part 'heart_rate_batch.g.dart';

/// 심박 배치 v2(`stream == 'hr'`). 본문에 memberId 를 넣지 않는다 — 인증된 회원으로 저장된다.
@freezed
abstract class HeartRateBatch with _$HeartRateBatch implements SensorUpload {
  const factory HeartRateBatch({
    @Default(2) int v,
    @Default('hr') String stream,
    @JsonKey(name: 'batch_id') required String batchId,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'session_id') required String sessionId,
    required int seq,
    @JsonKey(name: 'study_id') String? studyId,
    @JsonKey(name: 'participation_id') String? participationId,
    @JsonKey(name: 'run_id') String? runId,
    @JsonKey(toJson: nestedToJson) required ClockInfo clock,
    @JsonKey(toJson: listToJson) required List<HeartRateSample> samples,
    @JsonKey(name: 'on_body') required bool onBody,
    @JsonKey(name: 'watch_battery_pct') int? watchBatteryPct,
    @JsonKey(name: 'phone_received_at_ms') int? phoneReceivedAtMs,
    @JsonKey(toJson: nestedToJson) ResendInfo? resend,
  }) = _HeartRateBatch;

  factory HeartRateBatch.fromJson(Map<String, dynamic> json) =>
      _$HeartRateBatchFromJson(json);
}

@freezed
abstract class HeartRateSample with _$HeartRateSample {
  const factory HeartRateSample({
    required int bpm,
    @JsonKey(name: 'ts_ms') required int tsMs,

    /// HIGH·MEDIUM·LOW·UNRELIABLE·UNKNOWN. 누락·null 은 서버가 거절한다.
    required String accuracy,
  }) = _HeartRateSample;

  factory HeartRateSample.fromJson(Map<String, dynamic> json) =>
      _$HeartRateSampleFromJson(json);
}
