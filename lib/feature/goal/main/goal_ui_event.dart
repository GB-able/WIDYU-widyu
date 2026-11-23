sealed class GoalUiEvent {
  const GoalUiEvent();
}

class VerifyMedicationSuccess extends GoalUiEvent {
  const VerifyMedicationSuccess(this.earnedPoint, this.currentPoint);

  final int earnedPoint;
  final int currentPoint;
}
