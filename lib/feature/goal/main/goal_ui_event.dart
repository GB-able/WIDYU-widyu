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

class VerifyMeidcineSuccess extends GoalUiEvent {
  const VerifyMeidcineSuccess(this.earnedPoint, this.existingPoint);

  final int earnedPoint;
  final int existingPoint;
}
