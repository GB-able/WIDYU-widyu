import 'package:widyu/core/data/source/device/heartbeat_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/api_client.dart';

class HeartbeatRemoteDataSourceImpl implements HeartbeatRemoteDataSource {
  HeartbeatRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<bool> send(Map<String, dynamic> heartbeat) async {
    try {
      final response = await _apiClient.req(
        path: '/device/heartbeats',
        method: HttpMethod.post,
        body: heartbeat,
      );
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) return true;
      final data = response.data;
      WiduLog.data.w('하트비트 전송 실패 status=$status '
          'code=${data is Map ? data['code'] : null}');
      return false;
    } catch (error, stack) {
      WiduLog.data.w('하트비트 전송 실패', error: error, stackTrace: stack);
      return false;
    }
  }
}
