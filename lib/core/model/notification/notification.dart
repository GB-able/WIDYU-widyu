import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class Notification with _$Notification {
  const factory Notification({
    required int notificationId,
    @Default('') String image,
    required String category,
    required String title,
    @Default('') String content,
    required String createdAt,
    @Default(false) bool isRead,
    @Default('') String path,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
