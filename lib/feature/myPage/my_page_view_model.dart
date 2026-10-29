import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';

class MyPageViewModel with ChangeNotifier {
  final MyPageRepository _repository;
  final AuthRepository _authRepository;
  final PointRepository _pointRepository;
  final FcmTokenService _fcmTokenService;
  late final StreamSubscription<PointStatus> _pointStatus;

  MyPageUiState _uiState = const MyPageUiState();
  MyPageUiState get uiState => _uiState;

  final _uiEvent = StreamController<MyPageUiEvent>.broadcast();
  Stream<MyPageUiEvent> get uiEvent => _uiEvent.stream;

  String _appVersion = '';
  String get appVersion => _appVersion;

  MyPageViewModel({
    required MyPageRepository repository,
    required AuthRepository authRepository,
    required PointRepository pointRepository,
    required FcmTokenService fcmTokenService,
  })  : _repository = repository,
        _authRepository = authRepository,
        _pointRepository = pointRepository,
        _fcmTokenService = fcmTokenService {
    _applyPointStatus(pointRepository.currentStatus);
    _pointStatus = pointRepository.status.listen((status) {
      _applyPointStatus(status);
      notifyListeners();
    });
    fetchUser();
    _fetchAppVersion();
  }

  void _applyPointStatus(PointStatus status) {
    _uiState = _uiState.copyWith(
      point: status.point,
      isPointLoading: status.isLoading,
    );
  }

  Future<void> fetchUser() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchUser();
    if (result is Success) {
      final user = (result as Success<User>).data;
      _pointRepository.sync(user.points);
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
    await _fcmTokenService.deactivateToken();
    if (await _authRepository.logout() is Success) {
      WiduLog.ui.i('로그아웃 성공');
      _uiEvent.add(const LogoutSuccess());
    } else {
      _fcmTokenService.start();
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
    _pointStatus.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
