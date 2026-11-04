import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';

part 'my_page_view_model.g.dart';

@riverpod
class MyPageViewModel extends _$MyPageViewModel {
  final _uiEvent = StreamController<MyPageUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<MyPageUiEvent> get uiEvent => _uiEvent.stream;

  MyPageRepository get _repository => ref.read(myPageRepositoryProvider);
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);
  PointRepository get _pointRepository => ref.read(pointRepositoryProvider);
  FcmTokenService get _fcmTokenService => ref.read(fcmTokenServiceProvider);

  @override
  MyPageUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_start));
    final status = _pointRepository.currentStatus;
    return MyPageUiState(
      isLoading: true,
      point: status.point,
      isPointLoading: status.isLoading,
    );
  }

  void _start() {
    if (!ref.mounted) return;
    // 구독하면 최신 값이 다시 전달된다. 전달 시점이 stream 구현에 따라 다르므로
    // build() 중에 state를 쓰지 않도록 build() 뒤에 구독한다.
    final pointStatus = _pointRepository.status.listen((status) {
      state = state.copyWith(
        point: status.point,
        isPointLoading: status.isLoading,
      );
    });
    ref.onDispose(pointStatus.cancel);
    // 프로필에서 이름·사진이 바뀐 경우에만 다시 조회한다. 포인트는 위 구독으로 반영된다.
    final userChanges =
        _repository.userChanges.listen((_) => unawaited(_fetchUser()));
    ref.onDispose(userChanges.cancel);
    unawaited(_fetchUser());
    unawaited(_fetchAppVersion());
  }

  Future<void> _fetchUser() async {
    final pointRepository = _pointRepository;
    final pointRevision = pointRepository.revision;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchUser();
    // 화면이 먼저 닫혀도 세션 포인트는 갱신한다(기존 동작).
    if (result is Success<User>) {
      pointRepository.sync(result.data.points, revision: pointRevision);
    }
    if (!ref.mounted) return;
    if (result is Success) {
      final user = (result as Success<User>).data;
      state = state.copyWith(
        profileImage: user.profileImage,
        name: user.name,
      );
    } else {
      _uiEvent.add(const FetchUserFailure());
    }
    state = state.copyWith(isLoading: false);
  }

  Future<void> logout() async {
    // 화면이 먼저 닫혀도 토큰·세션 처리는 끝까지 한다(기존 동작).
    final fcmTokenService = _fcmTokenService;
    final authRepository = _authRepository;
    await fcmTokenService.deactivateToken();
    if (await authRepository.logout() is Success) {
      WiduLog.ui.i('로그아웃 성공');
      if (ref.mounted) _uiEvent.add(const LogoutSuccess());
    } else {
      fcmTokenService.start();
      if (ref.mounted) _uiEvent.add(const LogoutFailure());
    }
  }

  Future<void> _fetchAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!ref.mounted) return;
    state = state.copyWith(appVersion: info.version);
  }
}
