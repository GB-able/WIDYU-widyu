import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/notification/notification.dart';

part 'notification_page.freezed.dart';
part 'notification_page.g.dart';

@freezed
abstract class NotificationPage with _$NotificationPage {
  const factory NotificationPage({
    required List<Notification> notifications,
    required bool hasNext,
    required int nextCursor,
  }) = _NotificationPage;

  factory NotificationPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationPageFromJson(json);
}
