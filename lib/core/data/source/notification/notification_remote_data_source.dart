import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';

abstract class NotificationRemoteDataSource {
  Future<ApiResponse<List<NotificationSetting>>> fetchNotificationSettings();

  Future<ApiResponse<NotificationSetting>> updateNotificationSetting(
      NotificationSetting setting);

  Future<ApiResponse<NotificationPage>> fetchNotificationPage(int? cursor);

  Future<ApiResponse<void>> markAsRead(int notificationId);
}
