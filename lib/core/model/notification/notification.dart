import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required int notificationId,
    required String image,
    required String title,
    required String content,
    required String createdAt,
    required String scheme,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
