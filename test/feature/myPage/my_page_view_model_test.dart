import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_view_model.dart';

class _Repository extends Fake implements MyPageRepository {
  final pending = Completer<ApiResult<User>>();
  final _changes = StreamController<void>.broadcast();
  int calls = 0;

  @override
  Stream<void> get userChanges => _changes.stream;

  void change() => _changes.add(null);

  @override
  Future<ApiResult<User>> fetchUser() {
    calls++;
    return pending.future;
  }
}

class _Auth extends Fake implements AuthRepository {
  ApiResult<void> result = const ApiResult.failure('error');
  Completer<ApiResult<void>>? pending;

  @override
  Future<ApiResult<void>> logout() => pending?.future ?? Future.value(result);
}

class _Point extends Fake implements PointRepository {
  final _status = StreamController<PointStatus>.broadcast();
  int? synced;

  @override
  Stream<PointStatus> get status => _status.stream;

  @override
  PointStatus get currentStatus => (point: 10, isLoading: false);

  @override
  int get revision => 0;

  @override
  void sync(int? point, {required int revision}) => synced = point;

  void emit(PointStatus status) => _status.add(status);
}

class _Fcm extends Fake implements FcmTokenService {
  int deactivated = 0;
  int started = 0;

  @override
  Future<void> deactivateToken() async => deactivated++;

  @override
  void start() => started++;
}

const _user = User(memberId: 1, name: '홍길동', points: 30);

void main() {
  late _Repository repository;
  late _Auth auth;
  late _Point point;
  late _Fcm fcm;
  late ProviderContainer container;
  late List<MyPageUiEvent> events;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'widyu',
      packageName: 'com.widucorp.widu',
      version: '1.2.3',
      buildNumber: '1',
      buildSignature: '',
    );
    repository = _Repository();
    auth = _Auth();
    point = _Point();
    fcm = _Fcm();
    container = ProviderContainer.test(overrides: [
      myPageRepositoryProvider.overrideWithValue(repository),
      authRepositoryProvider.overrideWithValue(auth),
      pointRepositoryProvider.overrideWithValue(point),
      fcmTokenServiceProvider.overrideWithValue(fcm),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  // setUp과 테스트 본문 사이에도 microtask가 돌므로 테스트 안에서 부른다.
  void listen() {
    container.listen(myPageViewModelProvider, (_, __) {});
    container.read(myPageViewModelProvider.notifier).uiEvent.listen(events.add);
  }

  test('조회 시작 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    // 가드가 없으면 폐기된 Notifier의 state에 접근하다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(repository.calls, 0);
    expect(events, isEmpty);
  });

  test('조회 중 폐기돼도 세션 포인트는 갱신하고 화면 상태는 쓰지 않는다', () async {
    listen();
    await pumpEventQueue();
    expect(repository.calls, 1);

    container.dispose();
    repository.pending.complete(const ApiResult.success(_user));
    // 가드가 없으면 폐기된 Notifier의 state에 쓰다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(point.synced, 30);
    expect(events, isEmpty);
  });

  test('현재 포인트로 시작하고 사용자와 앱 버전을 불러온다', () async {
    listen();
    expect(container.read(myPageViewModelProvider).point, 10);
    await pumpEventQueue();

    repository.pending.complete(const ApiResult.success(_user));
    await pumpEventQueue();
    final state = container.read(myPageViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.name, '홍길동');
    expect(state.appVersion, '1.2.3');
  });

  test('로그아웃에 성공하면 토큰을 해제하고 성공을 알린다', () async {
    auth.result = const ApiResult.success(null);
    listen();

    await container.read(myPageViewModelProvider.notifier).logout();
    await pumpEventQueue();
    expect(fcm.deactivated, 1);
    expect(fcm.started, 0);
    expect(events.single, isA<LogoutSuccess>());
  });

  test('로그아웃에 실패하면 토큰 등록을 다시 시작하고 실패를 알린다', () async {
    listen();

    await container.read(myPageViewModelProvider.notifier).logout();
    await pumpEventQueue();
    expect(fcm.started, 1);
    expect(events.single, isA<LogoutFailure>());
  });

  test('사용자 정보가 바뀌었을 때만 다시 조회한다', () async {
    listen();
    await pumpEventQueue();
    expect(repository.calls, 1);

    repository.change();
    await pumpEventQueue();
    expect(repository.calls, 2);
  });

  test('포인트 상태가 바뀌면 포인트와 로딩 여부를 반영한다', () async {
    listen();
    await pumpEventQueue();

    point.emit((point: 20, isLoading: true));
    await pumpEventQueue();
    final state = container.read(myPageViewModelProvider);
    expect(state.point, 20);
    expect(state.isPointLoading, isTrue);
  });

  test('로그아웃 중 폐기돼도 실패 처리는 하고 이벤트는 쓰지 않는다', () async {
    auth.pending = Completer();
    listen();
    final logout = container.read(myPageViewModelProvider.notifier).logout();
    await pumpEventQueue();

    container.dispose();
    auth.pending!.complete(const ApiResult.failure('error'));
    // 가드가 없으면 닫힌 이벤트 stream에 쓰다가 예외가 나서 실패한다.
    await logout;
    await pumpEventQueue();
    expect(fcm.started, 1);
    expect(events, isEmpty);
  });
}
