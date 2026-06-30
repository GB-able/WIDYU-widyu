// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      notificationId: (json['notificationId'] as num).toInt(),
      image: json['image'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      scheme: json['scheme'] as String,
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'image': instance.image,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'scheme': instance.scheme,
    };
