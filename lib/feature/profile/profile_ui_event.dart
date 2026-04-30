sealed class ProfileUiEvent {
  const ProfileUiEvent();
}

class FetchProfileFailure extends ProfileUiEvent {
  const FetchProfileFailure();
}

class UpdateNameFailure extends ProfileUiEvent {
  const UpdateNameFailure();
}

class UpdateProfileImageFailure extends ProfileUiEvent {
  const UpdateProfileImageFailure();
}
