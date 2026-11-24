import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';

part 'goal_ui_state.freezed.dart';

@freezed
abstract class GoalUiState with _$GoalUiState {
  const GoalUiState._();

  const factory GoalUiState({
    @Default(true) bool isLoading,
    // 약·걸음·일정이 모두 비어 있어도 정상 응답이라, 실패는 따로 표시한다.
    @Default(false) bool hasError,
    int? point,
    Medication? medicine,
    @Default(0) int stepGoal,
    @Default([]) List<DailyHealthSchedule> visits,
  }) = _GoalUiState;

  /// 걸음 목표를 정해 둔 경우에만 걸음 수 카드를 보여 준다.
  bool get hasStepGoal => stepGoal > 0;
}
