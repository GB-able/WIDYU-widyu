import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';

abstract class NotificationRepository {
  Future<ApiResult<List<NotificationSetting>>> fetchNotificationSettings();

  Future<ApiResult<void>> updateNotificationSettings(
      NotificationSetting setting);
}
