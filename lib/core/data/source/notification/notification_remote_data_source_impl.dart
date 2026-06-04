import 'package:widyu/core/data/source/notification/notification_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/fcm/settings';

  @override
  Future<ApiResponse<List<NotificationSetting>>>
      fetchNotificationSettings() async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.get,
      );
      return response.toApiResponses(NotificationSetting.fromJson);
    } catch (e) {
      throw Exception("알림 설정 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<NotificationSetting>> updateNotificationSetting(
      NotificationSetting setting) async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.patch,
        body: setting.toJson(),
      );
      return response.toApiResponse(NotificationSetting.fromJson);
    } catch (e) {
      throw Exception("알림 설정 변경에 실패했습니다: $e");
    }
  }
}
