import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<NotificationSetting>>> fetchNotificationSettings();

  Future<ApiResult<void>> updateNotificationSettings(
      NotificationSetting setting);

  Future<ApiResult<NotificationPage>> fetchNotificationPage(int? cursor);

  Future<ApiResult<void>> markAsRead(int notificationId);
}
