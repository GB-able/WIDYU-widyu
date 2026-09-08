sealed class LocationSetupUiEvent {
  const LocationSetupUiEvent();
}

class LocationSetupNavigateHome extends LocationSetupUiEvent {
  const LocationSetupNavigateHome();
}

class LocationSetupFailure extends LocationSetupUiEvent {
  final String message;

  const LocationSetupFailure(this.message);
}
