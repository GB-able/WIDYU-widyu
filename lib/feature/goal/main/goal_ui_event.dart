sealed class GoalUiEvent {
  const GoalUiEvent();
}

class FetchWeeklyStatusFailure extends GoalUiEvent {
  const FetchWeeklyStatusFailure();
}

class VerifyMedicineFailure extends GoalUiEvent {
  const VerifyMedicineFailure(this.message);

  final String message;
}

class VerifyMeidcineSuccess extends GoalUiEvent {
  const VerifyMeidcineSuccess(this.earnedPoint, this.existingPoint);

  final int earnedPoint;
  final int existingPoint;
}
