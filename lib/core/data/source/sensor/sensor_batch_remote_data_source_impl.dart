import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';

class SensorBatchRemoteDataSourceImpl implements SensorBatchRemoteDataSource {
  SensorBatchRemoteDataSourceImpl({
    required SocketClient socketClient,
    required ApiClient apiClient,
  })  : _socketClient = socketClient,
        _apiClient = apiClient;

  final SocketClient _socketClient;
  final ApiClient _apiClient;

  @override
  Stream<bool> get connectionState => _socketClient.connectionState;

  @override
  bool sendBatch(SensorBatch batch) =>
      _socketClient.sendSensorBatch(batch.toJson());

  /// 폐기 레코드도 배치와 같은 목적지로 보낸다.
  /// 서버가 이 경로로 폐기 레코드를 받는지는 미확인이다(스키마 확정 시 조정).
  @override
  bool sendDropped(SensorDroppedRecord record) =>
      _socketClient.sendSensorBatch(record.toJson());

  @override
  Future<bool> resendBatches(List<SensorBatch> batches) async {
    try {
      // ApiClient 가 /api 와 /v1 을 붙이므로 최종 경로는 /api/v1/sensor/batches 다.
      // {"batches": [...]} 래핑은 서버 요청 스키마 확정 전까지의 가정이다.
      final response = await _apiClient.req(
        path: '/sensor/batches',
        method: HttpMethod.post,
        body: {'batches': batches.map((batch) => batch.toJson()).toList()},
      );
      final status = response.statusCode;
      return status != null && status >= 200 && status < 300;
    } catch (_) {
      return false;
    }
  }
}
