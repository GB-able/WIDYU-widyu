import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification_group.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';

part 'notification_setting_ui_model.freezed.dart';

@freezed
abstract class NotificationSettingUiModel with _$NotificationSettingUiModel {
  const factory NotificationSettingUiModel({
    required NotificationGroup group,
    required bool enabled,
    @Default(false) bool isUpdating,
  }) = _NotificationSettingUiModel;
}

extension NotificationGroupOrder on NotificationGroup {
  int get displayOrder => switch (this) {
        NotificationGroup.etc => 0,
        NotificationGroup.album => 1,
        NotificationGroup.goal => 2,
        NotificationGroup.home => 3,
      };

  String get name => switch (this) {
        NotificationGroup.etc => '공통',
        NotificationGroup.album => '앨범',
        NotificationGroup.goal => '목표',
        NotificationGroup.home => '홈',
      };

  String get description => switch (this) {
        NotificationGroup.etc => '문자 알림',
        NotificationGroup.album => '새 게시글, 댓글 알림',
        NotificationGroup.goal => '약 복용, 일정, 걷기 알림',
        NotificationGroup.home => '심박수 주의 알림',
      };
}

extension NotificationSettingsMapper on List<NotificationSetting> {
  List<NotificationSettingUiModel> toUiModel() {
    final sorted = [...this]
      ..sort((a, b) => a.group.displayOrder.compareTo(b.group.displayOrder));
    return sorted.map((setting) {
      return NotificationSettingUiModel(
        group: setting.group,
        enabled: setting.enabled,
      );
    }).toList();
  }
}

extension NotificationSettingUiModelMapper on NotificationSettingUiModel {
  NotificationSetting toDomain() => NotificationSetting(
        group: group,
        groupName: group.name,
        enabled: enabled,
      );
}
