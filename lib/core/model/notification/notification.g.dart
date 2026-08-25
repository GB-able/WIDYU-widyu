// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    _Notification(
      notificationId: (json['notificationId'] as num).toInt(),
      image: json['image'] as String,
      category: $enumDecode(_$NotificationCategoryEnumMap, json['category']),
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      scheme: json['scheme'] as String,
    );

Map<String, dynamic> _$NotificationToJson(_Notification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'image': instance.image,
      'category': _$NotificationCategoryEnumMap[instance.category]!,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'scheme': instance.scheme,
    };

const _$NotificationCategoryEnumMap = {
  NotificationCategory.album: 'ALBUM',
  NotificationCategory.target: 'TARGET',
  NotificationCategory.healthSchedule: 'HEALTH_SCHEDULE',
  NotificationCategory.walk: 'WALK',
  NotificationCategory.medicineSchedule: 'MEDICINE_SCHEDULE',
  NotificationCategory.heartMessage: 'HEART_MESSAGE',
  NotificationCategory.safeZone: 'SAFE_ZONE',
  NotificationCategory.etc: 'ETC',
};
