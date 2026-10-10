import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_dropped_record.dart';
import 'package:widyu/core/model/sensor/sensor_result.dart';

abstract class SensorBatchRemoteDataSource {
  bool sendBatch(SensorUpload batch);

  /// REST 재전송. 같은 `batch_id`·원문 바이트로 보내야 하므로 호출자가 배치를 바꾸면 안 된다.
  Future<ResendOutcome> resendBatch(SensorUpload batch);

  bool sendDropped(SensorDroppedRecord record);

  Stream<bool> get connectionState;

  /// STOMP 로 보낸 배치의 처리 결과.
  Stream<SensorResult> get results;
}
