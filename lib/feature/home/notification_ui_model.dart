import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification.dart';

part 'notification_ui_model.freezed.dart';

@freezed
abstract class NotificationUiModel with _$NotificationUiModel {
  const factory NotificationUiModel({
    required int notificationId,
    required String icon,
    required String description,
  }) = _NotificationUiModel;
}

extension NotificationMapper on List<Notification> {
  List<NotificationUiModel> toUiModel() {
    return where((notification) => !notification.isRead).map((notification) {
      return NotificationUiModel(
        notificationId: notification.notificationId,
        icon: notification.image,
        description: notification.title,
      );
    }).toList();
  }
}
