import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/goal/hospital/hospital.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/walk/walk.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';

part 'goal_ui_state.freezed.dart';

enum MedicationVerifyStatus { pending, verified, expired }

@freezed
sealed class GoalCardsState with _$GoalCardsState {
  const factory GoalCardsState.loading() = GoalCardsLoading;

  const factory GoalCardsState.error() = GoalCardsError;

  const factory GoalCardsState.data({
    Medication? medicine,
    Walk? walk,
    Hospital? hospital,
    @Default(Duration.zero) Duration verifyRemaining,
    @Default(MedicationVerifyStatus.pending)
    MedicationVerifyStatus verifyStatus,
    File? proofPhoto,
  }) = GoalCardsData;
}

@freezed
abstract class GoalUiState with _$GoalUiState {
  const GoalUiState._();

  const factory GoalUiState({
    @Default(GoalCardsState.loading()) GoalCardsState cards,
    @Default(true) bool isWeeklyLoading,
    @Default([]) List<GoalRateStatus> weeklyStatuses,
  }) = _GoalUiState;

  bool get isLoading => isWeeklyLoading || cards is GoalCardsLoading;
}
