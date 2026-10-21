import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_goal_status_response.freezed.dart';
part 'weekly_goal_status_response.g.dart';

enum GoalRateStatus {
  @JsonValue('NOT_STARTED')
  notStarted,
  @JsonValue('IN_PROGRESS')
  inProgress,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('FAILED')
  failed,
}

@freezed
abstract class WeeklyGoalStatusResponse with _$WeeklyGoalStatusResponse {
  const factory WeeklyGoalStatusResponse({
    @JsonKey(name: 'thisWeekGoalRates')
    @Default([])
    List<GoalRateStatus> statuses,
  }) = _WeeklyGoalStatusResponse;

  factory WeeklyGoalStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyGoalStatusResponseFromJson(json);
}
