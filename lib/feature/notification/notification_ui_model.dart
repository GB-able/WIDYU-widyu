import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification_group.dart';

part 'notification_ui_model.freezed.dart';

enum NotificationFilter {
  all('전체', null),
  unread('안읽음', null),
  goal('목표', NotificationGroup.goal),
  album('앨범', NotificationGroup.album),
  home('홈', NotificationGroup.home),
  etc('공통', NotificationGroup.etc);

  const NotificationFilter(this.label, this.group);

  final String label;
  final NotificationGroup? group;

  bool get isUnreadOnly => this == NotificationFilter.unread;
}

extension NotificationGroupTitle on NotificationGroup {
  String get title => switch (this) {
        NotificationGroup.goal => '목표',
        NotificationGroup.album => '앨범',
        NotificationGroup.home => '홈',
        NotificationGroup.etc => '공통',
      };
}

@freezed
abstract class NotificationItemUiModel with _$NotificationItemUiModel {
  const factory NotificationItemUiModel({
    required int notificationId,
    required NotificationGroup group,
    required String title,
    required String content,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationItemUiModel;
}
