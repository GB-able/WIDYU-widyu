sealed class SafetyCheckUiEvent {
  const SafetyCheckUiEvent();
}

class RespondFailure extends SafetyCheckUiEvent {
  const RespondFailure();
}

class CloseScreen extends SafetyCheckUiEvent {
  const CloseScreen();
}
