import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';

class MyPageViewModel with ChangeNotifier {
  final MyPageRepository _repository;
  final AuthRepository _authRepository;
  final PointProvider _pointProvider;

  MyPageUiState _uiState = const MyPageUiState();
  MyPageUiState get uiState => _uiState;

  final _uiEvent = StreamController<MyPageUiEvent>.broadcast();
  Stream<MyPageUiEvent> get uiEvent => _uiEvent.stream;

  String _appVersion = '';
  String get appVersion => _appVersion;

  MyPageViewModel({
    required MyPageRepository repository,
    required AuthRepository authRepository,
    required PointProvider pointProvider,
  })  : _repository = repository,
        _authRepository = authRepository,
        _pointProvider = pointProvider {
    fetchUser();
    unawaited(_pointProvider.ensureLoaded());
    _fetchAppVersion();
  }

  Future<void> fetchUser() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchUser();
    if (result is Success) {
      final user = (result as Success<User>).data;
      _pointProvider.sync(user.points);
      _uiState = _uiState.copyWith(
        profileImage: user.profileImage,
        name: user.name,
      );
    } else {
      _uiEvent.add(const FetchUserFailure());
    }
    _uiState = _uiState.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> logout() async {
    if (await _authRepository.logout() is Success) {
      _uiEvent.add(const LogoutSuccess());
    } else {
      _uiEvent.add(const LogoutFailure());
    }
  }

  Future<void> _fetchAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    _appVersion = info.version;
    notifyListeners();
  }

  @override
  void dispose() {
    _uiEvent.close();
    super.dispose();
  }
}
