// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_dropped_record.freezed.dart';
part 'sensor_dropped_record.g.dart';

/// 워치 큐가 넘쳐 버린 IMU 배치 구간. 폰 네이티브가 이 형태로 넘긴다.
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
