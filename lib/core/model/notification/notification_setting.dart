import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification_group.dart';

part 'notification_setting.freezed.dart';
part 'notification_setting.g.dart';

@freezed
abstract class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required NotificationGroup group,
    required String groupName,
    required bool enabled,
  }) = _NotificationSetting;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingFromJson(json);
}
