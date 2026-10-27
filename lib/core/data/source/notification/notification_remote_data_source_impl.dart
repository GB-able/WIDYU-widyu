import 'package:widyu/core/data/source/notification/notification_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/fcm';

  @override
  Future<ApiResponse<List<NotificationSetting>>>
      fetchNotificationSettings() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/settings',
        method: HttpMethod.get,
      );
      return response.toApiResponses(NotificationSetting.fromJson);
    } catch (e) {
      throw Exception('알림 설정 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<NotificationSetting>> updateNotificationSetting(
      NotificationSetting setting) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/settings',
        method: HttpMethod.patch,
        body: setting.toJson(),
      );
      return response.toApiResponse(NotificationSetting.fromJson);
    } catch (e) {
      throw Exception('알림 설정 변경에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<NotificationPage>> fetchNotificationPage(
      int? cursor) async {
    try {
      final response = await _apiClient.req(
        path: _path,
        method: HttpMethod.get,
        query: {
          if (cursor != null) 'cursor': cursor,
        },
      );
      return response.toApiResponse(NotificationPage.fromJson);
    } catch (e) {
      throw Exception('알림 조회에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<void>> readNotification(int notificationId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$notificationId',
        method: HttpMethod.patch,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception('알림 읽음 처리에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<void>> registerFcmToken(String token) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/token/login',
        method: HttpMethod.post,
        body: {'token': token},
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception('FCM 토큰 등록에 실패했습니다: $e');
    }
  }

  @override
  Future<ApiResponse<void>> deactivateFcmToken(String token) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/token/logout',
        method: HttpMethod.post,
        body: {'token': token},
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception('FCM 토큰 비활성화에 실패했습니다: $e');
    }
  }
}
