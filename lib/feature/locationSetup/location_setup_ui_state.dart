class LocationSetupUiState {
  final bool isLoading;
  final bool isConfiguring;
  final bool hasBackgroundLocation;
  final bool isLocationServiceEnabled;

  const LocationSetupUiState({
    this.isLoading = true,
    this.isConfiguring = false,
    this.hasBackgroundLocation = false,
    this.isLocationServiceEnabled = false,
  });

  LocationSetupUiState copyWith({
    bool? isLoading,
    bool? isConfiguring,
    bool? hasBackgroundLocation,
    bool? isLocationServiceEnabled,
  }) =>
      LocationSetupUiState(
        isLoading: isLoading ?? this.isLoading,
        isConfiguring: isConfiguring ?? this.isConfiguring,
        hasBackgroundLocation:
            hasBackgroundLocation ?? this.hasBackgroundLocation,
        isLocationServiceEnabled:
            isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      );
}
