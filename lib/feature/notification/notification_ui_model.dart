import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification.dart';

part 'notification_ui_model.freezed.dart';

@freezed
abstract class NotificationItemUiModel with _$NotificationItemUiModel {
  const factory NotificationItemUiModel({
    required int notificationId,
    required String image,
    required String category,
    required String title,
    required String content,
    required bool isRead,
    required DateTime createdAt,
    required String path,
  }) = _NotificationItemUiModel;

  factory NotificationItemUiModel.from(Notification notification) =>
      NotificationItemUiModel(
        notificationId: notification.notificationId,
        image: notification.image,
        category: notification.category,
        title: notification.title,
        content: notification.content,
        isRead: notification.isRead,
        createdAt: DateTime.tryParse(notification.createdAt) ?? DateTime.now(),
        path: notification.path,
      );
}
