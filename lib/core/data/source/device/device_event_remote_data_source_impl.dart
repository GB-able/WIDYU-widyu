import 'package:widyu/core/data/source/device/device_event_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/api_client.dart';

class DeviceEventRemoteDataSourceImpl implements DeviceEventRemoteDataSource {
  DeviceEventRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<String>?> send(List<Map<String, dynamic>> events) async {
    try {
      final response = await _apiClient.req(
        path: '/device/events',
        method: HttpMethod.post,
        body: events,
      );
      final status = response.statusCode ?? 0;
      // 배열이 아니거나 비었거나 500개를 넘은 경우다. 다시 보내도 같으므로 전부 거절로 본다.
      if (status == 400) {
        WiduLog.data.w('기기 이벤트 묶음 거절 count=${events.length}');
        return List.filled(events.length, 'REJECTED');
      }
      if (status < 200 || status >= 300) return null;
      final data = response.data;
      final results = data is Map ? data['data'] : null;
      if (results is! List) return null;
      return [
        for (final item in results)
          (item is Map ? item['result'] : null) as String? ?? 'REJECTED',
      ];
    } catch (_) {
      return null;
    }
  }
}
