import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_config.freezed.dart';
part 'sensor_config.g.dart';

/// `GET /api/v1/sensor/config` 의 `data`(camelCase). 기본값은 조회 실패 시에도 워치가 돌도록 서버 기본값과 같게 둔다.
@freezed
abstract class SensorConfig with _$SensorConfig {
  const factory SensorConfig({
    @Default('product') String collectionMode,
    @Default('continuous') String gyroMode,
    @Default(50) int accFsHz,
    @Default(1) int batchSec,
    @Default(1.8) double impactThresholdG,
    @Default(2) int backfillBeforeSec,
    @Default(10) int backfillAfterSec,

    /// 재조회 권고 간격(초).
    @Default(60) int refreshSec,
  }) = _SensorConfig;

  factory SensorConfig.fromJson(Map<String, dynamic> json) =>
      _$SensorConfigFromJson(json);
}
