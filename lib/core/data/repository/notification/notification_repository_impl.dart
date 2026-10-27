import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(
      {required NotificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<List<NotificationSetting>>>
      fetchNotificationSettings() async =>
          _remoteDataSource.fetchNotificationSettings().toApiResult();

  @override
  Future<ApiResult<NotificationSetting>> updateNotificationSettings(
          NotificationSetting setting) async =>
      _remoteDataSource.updateNotificationSetting(setting).toApiResult();

  @override
  Future<ApiResult<NotificationPage>> fetchNotificationPage(
          int? cursor) async =>
      _remoteDataSource.fetchNotificationPage(cursor).toApiResult();

  @override
  Future<ApiResult<void>> readNotification(int notificationId) async =>
      _remoteDataSource.readNotification(notificationId).toApiResult();

  @override
  Future<ApiResult<void>> registerFcmToken(String token) async =>
      _remoteDataSource.registerFcmToken(token).toApiResult();

  @override
  Future<ApiResult<void>> deactivateFcmToken(String token) async =>
      _remoteDataSource.deactivateFcmToken(token).toApiResult();
}
