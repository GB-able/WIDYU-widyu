// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_dropped_record.freezed.dart';
part 'sensor_dropped_record.g.dart';

/// 워치가 버린 배치 구간(서버 "버린 묶음" 기록). 폰 네이티브가 이 형태로 넘기고 그대로 서버에 보낸다.
@freezed
abstract class SensorDroppedRecord with _$SensorDroppedRecord {
  const factory SensorDroppedRecord({
    @Default('dropped') String stream,

    /// 버린 배치의 stream 값(`imu_watch`·`hr`).
    @JsonKey(name: 'dropped_stream') required String droppedStream,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'from_seq') required int fromSeq,
    @JsonKey(name: 'to_seq') required int toSeq,

    /// `queue_overflow`·`enqueue_failed`.
    required String reason,
    @JsonKey(name: 'ts_ms') required int tsMs,
  }) = _SensorDroppedRecord;

  factory SensorDroppedRecord.fromJson(Map<String, dynamic> json) =>
      _$SensorDroppedRecordFromJson(json);
}
