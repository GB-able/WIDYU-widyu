sealed class GoalUiEvent {
  const GoalUiEvent();
}

class FetchWeeklyStatusFailure extends GoalUiEvent {
  const FetchWeeklyStatusFailure();
}

class VerifyMedicationFailure extends GoalUiEvent {
  const VerifyMedicationFailure(this.message);

  final String message;
}

class VerifyMedicationSuccess extends GoalUiEvent {
  const VerifyMedicationSuccess(this.earnedPoint, this.currentPoint);

  final int earnedPoint;
  final int currentPoint;
}
