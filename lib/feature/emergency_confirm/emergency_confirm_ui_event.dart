sealed class EmergencyConfirmUiEvent {
  const EmergencyConfirmUiEvent();
}

class RespondFailure extends EmergencyConfirmUiEvent {
  const RespondFailure();
}

class CloseScreen extends EmergencyConfirmUiEvent {
  const CloseScreen();
}
