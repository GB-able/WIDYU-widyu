import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
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
  bool sendBatch(Map<String, dynamic> batch) =>
      _socketClient.sendSensorBatch(batch);

  @override
  Future<bool> resendBatches(List<Map<String, dynamic>> batches) async {
    try {
      // ApiClient 가 /api 를 붙이므로 최종 경로는 /api/v1/sensor/batches 다.
      // {"batches": [...]} 래핑은 서버 요청 스키마 확정 전까지의 가정이다.
      final response = await _apiClient.req(
        path: '/v1/sensor/batches',
        method: HttpMethod.post,
        body: {'batches': batches},
      );
      final status = response.statusCode;
      return status != null && status >= 200 && status < 300;
    } catch (_) {
      return false;
    }
  }
}
