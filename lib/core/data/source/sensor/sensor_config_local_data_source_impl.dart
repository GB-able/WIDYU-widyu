import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';

class SensorConfigLocalDataSourceImpl implements SensorConfigLocalDataSource {
  static const _channel = MethodChannel('com.widucorp.widu/sensor_config');

  /// 키 이름은 네이티브가 DataMap 에 그대로 옮기는 워치와의 계약이다. 바꾸지 말 것.
  @override
  Future<void> sendToWatch(SensorConfig config) async {
    try {
      await _channel.invokeMethod<void>('applyConfig', {
        'collection_mode': config.collectionMode,
        'gyro_mode': config.gyroMode,
        'acc_hz': config.accFsHz,
        'batch_sec': config.batchSec,
        'impact_g': config.impactThresholdG,
        'backfill_pre_sec': config.backfillBeforeSec,
        'backfill_post_sec': config.backfillAfterSec,
      });
    } on PlatformException catch (error) {
      WiduLog.data.w('워치로 센서 설정 전송 실패 code=${error.code}');
    } on MissingPluginException {
      WiduLog.data.w('센서 설정 채널 없음');
    }
  }
}
