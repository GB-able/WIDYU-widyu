// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSetting _$NotificationSettingFromJson(Map<String, dynamic> json) =>
    _NotificationSetting(
      group: $enumDecode(_$NotificationGroupEnumMap, json['group']),
      groupName: json['groupName'] as String,
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$NotificationSettingToJson(
        _NotificationSetting instance) =>
    <String, dynamic>{
      'group': _$NotificationGroupEnumMap[instance.group]!,
      'groupName': instance.groupName,
      'enabled': instance.enabled,
    };

const _$NotificationGroupEnumMap = {
  NotificationGroup.goal: 'GOAL',
  NotificationGroup.album: 'ALBUM',
  NotificationGroup.home: 'HOME',
  NotificationGroup.etc: 'ETC',
};
