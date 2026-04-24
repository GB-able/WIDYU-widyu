sealed class MyPageUiState {
  const MyPageUiState();
}

class Loading extends MyPageUiState {
  const Loading();
}

class Success extends MyPageUiState {
  const Success({
    this.profileImage,
    this.name = '',
    this.points = 0,
  });

  final String? profileImage;
  final String name;
  final int points;
}

class Failure extends MyPageUiState {
  const Failure();
}

extension MyPageUiStateExtension on MyPageUiState {
  String? get profileImage =>
      this is Success ? (this as Success).profileImage : null;
  String get name => this is Success ? (this as Success).name : '사용자';
  int get points => this is Success ? (this as Success).points : 0;
  bool get isLoading => this is Loading;
  bool get isError => this is Failure;
}
