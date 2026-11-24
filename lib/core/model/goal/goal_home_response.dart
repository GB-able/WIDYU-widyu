import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/hospital/hospital.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/walk/walk.dart';

part 'goal_home_response.freezed.dart';
part 'goal_home_response.g.dart';

@freezed
abstract class GoalHomeResponse with _$GoalHomeResponse {
  const factory GoalHomeResponse({
    required Medication? medicine,
    @JsonKey(name: 'steps') required Walk? walk,
    required Hospital? hospital,
    @Default([]) List<DailyHealthSchedule> todaySchedules,
  }) = _GoalHomeResponse;

  factory GoalHomeResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalHomeResponseFromJson(json);
}
