sealed class LoginUiState {
  const LoginUiState({
    this.isLoading = false,
    this.error,
  });

  final bool isLoading;
  final LoginError? error;
}

class LoginPhoneState extends LoginUiState {
  const LoginPhoneState({
    super.isLoading = false,
    super.error,
  });
}

class LoginCodeState extends LoginUiState {
  const LoginCodeState({
    super.isLoading = false,
    super.error,
  });
}

enum LoginError {
  loginFailed,
  loginFailedALot;

  String get message => switch (this) {
        loginFailed => '숫자를 다시 입력해보세요',
        loginFailedALot => '초대숫자를 잃어버렸다면, 보호자님께 확인을 요청하세요',
      };
}
