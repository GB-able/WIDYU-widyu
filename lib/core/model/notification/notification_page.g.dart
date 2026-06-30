// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPage _$NotificationPageFromJson(Map<String, dynamic> json) =>
    _NotificationPage(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['hasNext'] as bool,
      nextCursor: (json['nextCursor'] as num).toInt(),
    );

Map<String, dynamic> _$NotificationPageToJson(_NotificationPage instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'hasNext': instance.hasNext,
      'nextCursor': instance.nextCursor,
    };
