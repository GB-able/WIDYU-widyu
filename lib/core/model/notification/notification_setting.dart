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
    required int policyRevision,
    @JsonKey(includeToJson: false) @Default(true) bool recipientEnabled,
    @JsonKey(includeToJson: false) @Default(true) bool productPushEnabled,
    @JsonKey(includeToJson: false) @Default(false) bool mandatoryProductPush,
    @JsonKey(includeToJson: false) @Default(true) bool canEditProductPush,
    @JsonKey(includeToJson: false) @Default('unknown') String devicePushStatus,
  }) = _NotificationSetting;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingFromJson(json);
}
