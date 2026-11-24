import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate_batch.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_dropped_record.dart';

part 'sensor_message.freezed.dart';

/// 로컬 EventChannel 이 여러 종류를 한 스트림으로 흘리므로 `stream` 값으로 가른다.
@freezed
sealed class SensorMessage with _$SensorMessage {
  const factory SensorMessage.batch(SensorBatch batch) = SensorMessageBatch;

  const factory SensorMessage.heartRate(HeartRateBatch batch) =
      SensorMessageHeartRate;

  const factory SensorMessage.dropped(SensorDroppedRecord record) =
      SensorMessageDropped;

  /// 워치 상태 이벤트. 서버 `/device/events` 항목 원문이라 모델로 풀지 않고 그대로 올린다.
  const factory SensorMessage.deviceEvent(Map<String, dynamic> event) =
      SensorMessageDeviceEvent;

  /// freezed 의 runtimeType 기반 union JSON 대신 `stream` 값으로 분기하므로 static 이다.
  static SensorMessage fromJson(Map<String, dynamic> json) =>
      switch (json['stream']) {
        'dropped' =>
          SensorMessage.dropped(SensorDroppedRecord.fromJson(json)),
        'hr' => SensorMessage.heartRate(HeartRateBatch.fromJson(json)),
        'device_event' =>
          SensorMessage.deviceEvent(json['event'] as Map<String, dynamic>),
        _ => SensorMessage.batch(SensorBatch.fromJson(json)),
      };
}
