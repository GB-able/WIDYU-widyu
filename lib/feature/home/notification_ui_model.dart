import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification.dart';
import 'package:widyu/core/model/notification/notification_category.dart';

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
    return where((notification) => !notification.isRead)
        .map(
          (notification) => NotificationUiModel(
            notificationId: notification.notificationId,
            icon: notification.category.toIcon(),
            description: notification.title,
          ),
        )
        .toList();
  }
}

extension NotificationCategoryMapper on NotificationCategory {
  String toIcon() {
    return switch (this) {
      NotificationCategory.album => 'img_24_album.png',
      // 아이콘 추가 필요
      NotificationCategory.target => '',
      NotificationCategory.healthSchedule => 'img_24_health.png',
      NotificationCategory.walk => 'img_24_walk.png',
      NotificationCategory.medicineSchedule => 'img_24_medicine.png',
      // 아이콘 추가 필요
      NotificationCategory.heartMessage => '',
      NotificationCategory.safeZone => 'img_24_location.png',
      NotificationCategory.locationNotice => 'img_24_location.png',
      // 아이콘 추가 필요
      NotificationCategory.etc => '',
    };
  }
}
