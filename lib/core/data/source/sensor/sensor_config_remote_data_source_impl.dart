import 'package:widyu/core/data/source/sensor/sensor_config_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';
import 'package:widyu/core/network/api_client.dart';

class SensorConfigRemoteDataSourceImpl implements SensorConfigRemoteDataSource {
  SensorConfigRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<SensorConfig?> fetch() async {
    try {
      final response = await _apiClient.req(
        path: '/sensor/config',
        method: HttpMethod.get,
      );
      final status = response.statusCode ?? 0;
      final data = response.data;
      if (status < 200 || status >= 300 || data is! Map) return null;
      final config = data['data'];
      if (config is! Map) return null;
      return SensorConfig.fromJson(Map<String, dynamic>.from(config));
    } catch (error, stack) {
      WiduLog.data.w('센서 설정 조회 실패', error: error, stackTrace: stack);
      return null;
    }
  }
}
