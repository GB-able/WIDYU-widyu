import 'package:freezed_annotation/freezed_annotation.dart';

enum NotificationCategory {
  @JsonValue('ALBUM')
  album,
  @JsonValue('TARGET')
  target,
  @JsonValue('HEALTH_SCHEDULE')
  healthSchedule,
  @JsonValue('WALK')
  walk,
  @JsonValue('MEDICINE_SCHEDULE')
  medicineSchedule,
  @JsonValue('HEART_MESSAGE')
  heartMessage,
  @JsonValue('SAFE_ZONE')
  safeZone,
  @JsonValue('ETC')
  etc,
}
