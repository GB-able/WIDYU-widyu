import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification.dart';
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'notification_ui_model.freezed.dart';

@freezed
abstract class NotificationUiModel with _$NotificationUiModel {
  const factory NotificationUiModel({
    required int notificationId,
    required AssetGenImage? icon,
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
  AssetGenImage? toIcon() {
    return switch (this) {
      NotificationCategory.album => Assets.images.img24Album,
      // 아이콘 추가 필요
      NotificationCategory.target => null,
      NotificationCategory.healthSchedule => Assets.images.img24Health,
      NotificationCategory.walk => Assets.images.img24Walk,
      NotificationCategory.medicineSchedule => Assets.images.img24Medicine,
      // 아이콘 추가 필요
      NotificationCategory.heartMessage => null,
      NotificationCategory.safeZone => Assets.images.img24Location,
      NotificationCategory.locationNotice => Assets.images.img24Location,
      // 아이콘 추가 필요
      NotificationCategory.etc => null,
    };
  }
}
