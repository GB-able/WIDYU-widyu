import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';

part 'monthly_goal_ui_state.freezed.dart';

/// 한 날짜의 목표. 화면은 [date]가 바뀔 때 카드 묶음을 밀어 넣으며 교체한다.
@freezed
abstract class MonthlyGoalDay with _$MonthlyGoalDay {
  const factory MonthlyGoalDay({
    required DateTime date,
    @Default([]) List<DailyMedicineSchedule> medicines,
    @Default([]) List<DailyHealthSchedule> healthSchedules,
    // 걷기 조회에 실패했거나 목표가 없던 날은 null이다.
    WalkDaily? walk,
  }) = _MonthlyGoalDay;
}

@freezed
abstract class MonthlyGoalUiState with _$MonthlyGoalUiState {
  const MonthlyGoalUiState._();

  const factory MonthlyGoalUiState({
    required DateTime today,
    required DateTime focusedMonth,
    required DateTime selectedDay,
    @Default({}) Set<int> healthDays,
    // 새 날짜를 불러오는 동안에는 이전 날짜를 그대로 보여 준다.
    MonthlyGoalDay? day,
    @Default(true) bool isDayLoading,
    @Default(false) bool hasDayError,
  }) = _MonthlyGoalUiState;

  /// 서버가 조회를 허용하는 범위(이번 달 기준 앞뒤 12개월).
  DateTime get firstMonth => DateTime(today.year, today.month - 12);
  DateTime get lastMonth => DateTime(today.year, today.month + 12);
}
