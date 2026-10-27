sealed class MyPageUiEvent {
  const MyPageUiEvent();
}

class FetchUserFailure extends MyPageUiEvent {
  const FetchUserFailure();
}

class LogoutSuccess extends MyPageUiEvent {
  const LogoutSuccess();
}

class LogoutFailure extends MyPageUiEvent {
  const LogoutFailure();
}
