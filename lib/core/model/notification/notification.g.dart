// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      notificationId: (json['notificationId'] as num).toInt(),
      image: json['image'] as String? ?? '',
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      isRead: json['isRead'] as bool? ?? false,
      path: json['path'] as String? ?? '',
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'image': instance.image,
      'category': instance.category,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'path': instance.path,
    };
