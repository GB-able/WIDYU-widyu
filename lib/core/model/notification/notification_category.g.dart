// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationCategory _$NotificationCategoryFromJson(
        Map<String, dynamic> json) =>
    _NotificationCategory(
      label: json['label'] as String,
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$NotificationCategoryToJson(
        _NotificationCategory instance) =>
    <String, dynamic>{
      'label': instance.label,
      'name': instance.name,
      'count': instance.count,
    };
