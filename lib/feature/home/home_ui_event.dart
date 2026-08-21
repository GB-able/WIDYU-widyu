sealed class HomeUiEvent {
  const HomeUiEvent();
}

class FetchHeartRateFailure extends HomeUiEvent {
  const FetchHeartRateFailure();
}

class FetchNotificationFailure extends HomeUiEvent {
  const FetchNotificationFailure();
}

class FetchUserFailure extends HomeUiEvent {
  const FetchUserFailure();
}

class FetchSeniorCardFailure extends HomeUiEvent {
  const FetchSeniorCardFailure();
}

class RequestCameraPermissionFailure extends HomeUiEvent {
  const RequestCameraPermissionFailure();
}

class RequestCameraPermissionPermanentlyFailure extends HomeUiEvent {
  const RequestCameraPermissionPermanentlyFailure();
}

class OpenCameraFailure extends HomeUiEvent {
  const OpenCameraFailure();
}

class TakeMedicationPhotoSuccess extends HomeUiEvent {
  const TakeMedicationPhotoSuccess();
}
