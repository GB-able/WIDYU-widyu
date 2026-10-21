// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_goal_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyGoalStatusResponse _$WeeklyGoalStatusResponseFromJson(
        Map<String, dynamic> json) =>
    _WeeklyGoalStatusResponse(
      statuses: (json['thisWeekGoalRates'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GoalRateStatusEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WeeklyGoalStatusResponseToJson(
        _WeeklyGoalStatusResponse instance) =>
    <String, dynamic>{
      'thisWeekGoalRates':
          instance.statuses.map((e) => _$GoalRateStatusEnumMap[e]!).toList(),
    };

const _$GoalRateStatusEnumMap = {
  GoalRateStatus.notStarted: 'NOT_STARTED',
  GoalRateStatus.inProgress: 'IN_PROGRESS',
  GoalRateStatus.completed: 'COMPLETED',
  GoalRateStatus.failed: 'FAILED',
};
