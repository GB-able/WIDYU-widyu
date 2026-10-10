import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_result.freezed.dart';
part 'sensor_result.g.dart';

/// REST 재전송 1건의 결과. [stored]·[rejected] 는 큐에서 빼고, [retryLater] 만 같은 batch_id·원문으로 다시 시도한다.
enum ResendOutcome { stored, rejected, retryLater }

/// STOMP `/user/queue/sensor/result` 본문.
@freezed
abstract class SensorResult with _$SensorResult {
  const factory SensorResult({
    required String batchId,
    required int seq,
    required String result,
  }) = _SensorResult;

  factory SensorResult.fromJson(Map<String, dynamic> json) =>
      _$SensorResultFromJson(json);

  static const stored = 'STORED';
  static const duplicate = 'DUPLICATE';
  static const rejected = 'REJECTED';
}
