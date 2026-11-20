import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_health_schedule.freezed.dart';
part 'daily_health_schedule.g.dart';

/// 서버가 표시용으로 정한 건강 일정 상태. 예정 시각이 지나도 완료하지 않으면 [incomplete]가 된다.
enum HealthScheduleState {
  @JsonValue('UPCOMING')
  upcoming,
  @JsonValue('INCOMPLETE')
  incomplete,
  @JsonValue('COMPLETED')
  completed,
}

/// `GET /goals/health-schedules/daily/seniors` 의 일정 하나.
@freezed
abstract class DailyHealthSchedule with _$DailyHealthSchedule {
  const factory DailyHealthSchedule({
    required int healthScheduleId,
    required String scheduleName,
    required DateTime scheduledAt,
    String? placeAddress,
    double? latitude,
    double? longitude,
    required HealthScheduleState progressStatus,
  }) = _DailyHealthSchedule;

  factory DailyHealthSchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyHealthScheduleFromJson(json);
}
