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

  /// freezed 의 runtimeType 기반 union JSON 대신 `stream` 값으로 분기하므로 static 이다.
  static SensorMessage fromJson(Map<String, dynamic> json) =>
      switch (json['stream']) {
        'imu_dropped' =>
          SensorMessage.dropped(SensorDroppedRecord.fromJson(json)),
        'hr' => SensorMessage.heartRate(HeartRateBatch.fromJson(json)),
        _ => SensorMessage.batch(SensorBatch.fromJson(json)),
      };
}
