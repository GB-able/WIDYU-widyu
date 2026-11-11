import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/notification/notification.dart' as model;
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/home_view_model.dart';

import '../user_fakes.dart';

class _Home extends Fake implements HomeRepository {
  int? scheduleId = 7;
  StepProgress? walk;
  Completer<void>? pending;
  int fetches = 0;

  @override
  Future<ApiResult<SeniorCard>> fetchSeniorCard() async {
    fetches++;
    await pending?.future;
    return ApiResult.success(SeniorCard(
      heartRate: null,
      medicine: MedicationSummary(
        medicineScheduleId: scheduleId,
        todayTakenCount: null,
        todayTotalCount: null,
        nextDoseCount: 2,
        nextAlarmTime: null,
        scheduleStatuses: const [],
      ),
      albums: [],
      healthSchedule: const HealthSchedule(
        scheduleName: null,
        dday: null,
        scheduledAt: null,
        placeAddress: '병원',
        latitude: 37,
        longitude: 127,
      ),
      walk: walk,
    ));
  }
}

class _Notification extends Fake implements NotificationRepository {
  ApiResult<NotificationPage> page = const ApiResult.failure('unused');
  Completer<void>? pending;
  Completer<ApiResult<void>>? read;

  @override
  Future<ApiResult<NotificationPage>> fetchNotificationPage(
    int? cursor, {
    String? category,
  }) async {
    await pending?.future;
    return page;
  }

  @override
  Future<ApiResult<void>> readNotification(int notificationId) => read!.future;

  @override
  Future<ApiResult<List<NotificationCategory>>>
      fetchNotificationCategories() async => const ApiResult.failure('unused');
}

class _HeartRate extends Fake implements HeartRateRepository {
  // 테스트 하나가 끝나면 함께 버려지는 가짜 스트림이라 닫지 않는다.
  // ignore: close_sinks
  final connection = StreamController<bool>.broadcast();
  Completer<void>? pending;

  @override
  Future<ApiResult<HeartRateResponse>> fetchHeartRate() async {
    await pending?.future;
    return const ApiResult.failure('unused');
  }

  @override
  Stream<bool> observeConnection() => connection.stream;
}

class _Location extends Fake implements LocationRepository {
  int reads = 0;
  Future<UserLocation?> Function() read = () async => null;

  @override
  Future<UserLocation?> getCurrentLocation() {
    reads++;
    return read();
  }
}

class _Walk extends Fake implements WalkRepository {
  // 테스트 하나가 끝나면 함께 버려지는 가짜 스트림이라 닫지 않는다.
  // ignore: close_sinks
  final steps = StreamController<int>.broadcast();
  final applied = <(int, String, int?)>[];

  @override
  Stream<int> get todaySteps => steps.stream;

  @override
  int get currentTodaySteps => 0;

  @override
  void applyServerSteps(int serverSteps, {required String date, int? goal}) =>
      applied.add((serverSteps, date, goal));
}

class _Medication extends Fake implements MedicationRepository {
  // 테스트 하나가 끝나면 함께 버려지는 가짜 스트림이라 닫지 않는다.
  // ignore: close_sinks
  final changes = StreamController<void>.broadcast();

  @override
  Stream<void> get medicationChanges => changes.stream;
}

class _Harness {
  final home = _Home();
  final user = FakeUserRepository();
  final notification = _Notification();
  final heartRate = _HeartRate();
  final location = _Location();
  final walk = _Walk();
  final medication = _Medication();
  final events = <HomeUiEvent>[];
  final starts = <UserLocation?>[];
  int get photos => events.whereType<NavigateToMedicationCamera>().length;
  late ProviderContainer container;
  late HomeViewModel vm;

  HomeUiState get state => container.read(homeViewModelProvider);

  /// 화면이 열린 것처럼 ViewModel을 만든다. 시작 조회는 다음 microtask에 시작한다.
  void open({
    PermissionRequestResult permission = PermissionRequestResult.granted,
    PermissionSettingsResult settings = PermissionSettingsResult.granted,
    Future<PermissionRequestResult> Function()? readPermission,
    BackgroundLocationNoticeController? noticeController,
  }) {
    final recovery = PermissionRecoveryController(
      statusReader: (_) => readPermission?.call() ?? Future.value(permission),
      requester: (_) async => permission,
      rationaleReader: (_) async => false,
      settingsRechecker: (_, __) async => settings,
    );
    container = ProviderContainer.test(overrides: [
      homeRepositoryProvider.overrideWithValue(home),
      userRepositoryProvider.overrideWithValue(user),
      notificationRepositoryProvider.overrideWithValue(notification),
      heartRateRepositoryProvider.overrideWithValue(heartRate),
      locationRepositoryProvider.overrideWithValue(location),
      walkRepositoryProvider.overrideWithValue(walk),
      medicationRepositoryProvider.overrideWithValue(medication),
      // 폐기 시 대기 중인 권한 요청을 취소하도록 provider 폐기와 연결한다.
      homePermissionRecoveryControllerProvider.overrideWith((ref) {
        ref.onDispose(recovery.dispose);
        return recovery;
      }),
      backgroundLocationNoticeControllerProvider.overrideWithValue(
        noticeController ??
            BackgroundLocationNoticeController(
              foregroundPermissionReader: () async => false,
            ),
      ),
      kakaoMapRouteOpenerProvider.overrideWithValue(({
        required UserLocation destination,
        UserLocation? start,
        String? destinationName,
        KakaoMapRouteType routeType = KakaoMapRouteType.publicTransit,
      }) async {
        expect(destination.latitude, 37);
        expect(destination.longitude, 127);
        expect(destinationName, '병원');
        starts.add(start);
        return true;
      }),
    ]);
    container.listen(homeViewModelProvider, (_, __) {});
    vm = container.read(homeViewModelProvider.notifier);
  }

  /// 시작 조회가 끝난 뒤부터 이벤트를 모은다(시작 조회 실패 안내는 제외).
  Future<void> initialize({
    PermissionRequestResult permission = PermissionRequestResult.granted,
    PermissionSettingsResult settings = PermissionSettingsResult.granted,
    Future<PermissionRequestResult> Function()? readPermission,
    BackgroundLocationNoticeController? noticeController,
  }) async {
    open(
      permission: permission,
      settings: settings,
      readPermission: readPermission,
      noticeController: noticeController,
    );
    await Future<void>.delayed(Duration.zero);
    vm.uiEvent.listen(events.add);
  }

  void dispose() => container.dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('카메라는 허용 시 일정 ID와 약 개수를 담아 촬영 화면 이동을 알린다', () async {
    final h = _Harness();
    await h.initialize();
    await h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    expect(
      h.events.single,
      isA<NavigateToMedicationCamera>()
          .having((it) => it.scheduleId, 'scheduleId', 7)
          .having((it) => it.doseCount, 'doseCount', 2),
    );
  });

  test('복용 일정 ID가 없으면 촬영 화면으로 이동하지 않는다', () async {
    final h = _Harness();
    h.home.scheduleId = null;
    await h.initialize();
    await h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    expect(h.events.single, isA<MedicationScheduleUnavailable>());
  });

  test('카메라 거절은 촬영을 막고 권한 안내만 보낸다', () async {
    final h = _Harness();
    await h.initialize(permission: PermissionRequestResult.denied);
    await h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    expect(h.photos, 0);
    expect(h.events.single, isA<RequestCameraPermissionFailure>());
  });

  test('설정에서 카메라를 허용해도 자동 촬영하지 않는다', () async {
    final h = _Harness();
    await h.initialize(permission: PermissionRequestResult.permanentlyDenied);
    await h.vm.takeMedicationPhoto(
      showPrompt: (_, __) async => PermissionRecoveryAction.openSettings,
    );
    await Future<void>.delayed(Duration.zero);
    expect(h.photos, 0);
    expect(h.events.single, isA<CameraPermissionSettingsGranted>());
  });

  test('카메라 설정 안내 취소는 촬영과 실패 안내를 하지 않는다', () async {
    final h = _Harness();
    await h.initialize(permission: PermissionRequestResult.permanentlyDenied);
    await h.vm.takeMedicationPhoto();
    expect(h.photos, 0);
    expect(h.events, isEmpty);
  });

  for (final entry in {
    PermissionSettingsResult.denied: CameraPermissionSettingsDenied,
    PermissionSettingsResult.launchFailed:
        CameraPermissionSettingsLaunchFailure,
  }.entries) {
    test('카메라 설정 ${entry.key.name} 결과를 구분하고 촬영하지 않는다', () async {
      final h = _Harness();
      await h.initialize(
        permission: PermissionRequestResult.permanentlyDenied,
        settings: entry.key,
      );
      await h.vm.takeMedicationPhoto(
        showPrompt: (_, __) async => PermissionRecoveryAction.openSettings,
      );
      await Future<void>.delayed(Duration.zero);
      expect(h.photos, 0);
      expect(h.events.single.runtimeType, entry.value);
    });
  }

  test('지도는 위치 권한 거절 시 현재 위치 조회 없이 목적지만 연다', () async {
    final h = _Harness();
    await h.initialize(permission: PermissionRequestResult.denied);
    await h.vm.openHealthScheduleRoute();
    await Future<void>.delayed(Duration.zero);
    expect(h.location.reads, 0);
    expect(h.starts, [null]);
    expect(h.events.single, isA<LocationPermissionUnavailable>());
  });

  test('지도 설정 안내를 취소해도 목적지만 조용히 연다', () async {
    final h = _Harness();
    await h.initialize(permission: PermissionRequestResult.permanentlyDenied);
    await h.vm.openHealthScheduleRoute();
    expect(h.location.reads, 0);
    expect(h.starts, [null]);
    expect(h.events, isEmpty);
  });

  test('지도 권한 설정을 열지 못해도 목적지만 연다', () async {
    final h = _Harness();
    await h.initialize(
      permission: PermissionRequestResult.permanentlyDenied,
      settings: PermissionSettingsResult.launchFailed,
    );
    await h.vm.openHealthScheduleRoute(
      showPrompt: (_, __) async => PermissionRecoveryAction.openSettings,
    );
    await Future<void>.delayed(Duration.zero);
    expect(h.starts, [null]);
    expect(h.events.single, isA<LocationPermissionSettingsLaunchFailure>());
  });

  test('지도는 허용된 현재 위치를 출발지로 전달한다', () async {
    final h = _Harness();
    const origin = UserLocation(latitude: 36, longitude: 126);
    h.location.read = () async => origin;
    await h.initialize();
    await h.vm.openHealthScheduleRoute();
    expect(h.location.reads, 1);
    expect(h.starts, [origin]);
  });

  test('권한 확인 중 중복 탭을 막고 끝난 뒤에는 다시 시도할 수 있다', () async {
    final h = _Harness();
    final permission = Completer<PermissionRequestResult>();
    await h.initialize(readPermission: () => permission.future);
    final first = h.vm.takeMedicationPhoto();
    await h.vm.takeMedicationPhoto();
    permission.complete(PermissionRequestResult.granted);
    await first;
    await Future<void>.delayed(Duration.zero);
    expect(h.photos, 1);
    await h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    expect(h.photos, 2);
  });

  test('위치 조회 중 중복 실행과 화면 종료 후 지도 실행을 막는다', () async {
    final h = _Harness();
    final location = Completer<UserLocation?>();
    h.location.read = () => location.future;
    await h.initialize();
    final first = h.vm.openHealthScheduleRoute();
    await Future<void>.delayed(Duration.zero);
    await h.vm.openHealthScheduleRoute();
    expect(h.location.reads, 1);
    h.dispose();
    location.complete(null);
    await first;
    expect(h.starts, isEmpty);
  });

  for (final entry in {
    PermissionSettingsResult.launchFailed: 1,
    PermissionSettingsResult.granted: 0,
    PermissionSettingsResult.denied: 0,
  }.entries) {
    test('위치 항상 허용 안내를 한 번 알리고 설정 결과 ${entry.key.name}를 구분한다', () async {
      final h = _Harness();
      final gate = Completer<bool>();
      await h.initialize(
        noticeController: BackgroundLocationNoticeController(
          foregroundPermissionReader: () async => true,
          permissionReader: () => gate.future,
          settingsRechecker: (_) async => entry.key,
        ),
      );
      gate.complete(false);
      await Future<void>.delayed(Duration.zero);
      expect(h.events, [isA<ShowBackgroundLocationNotice>()]);

      await h.vm.openBackgroundLocationSettings();
      await Future<void>.delayed(Duration.zero);
      expect(
        h.events.whereType<BackgroundLocationSettingsLaunchFailure>().length,
        entry.value,
      );
    });
  }

  test('권한 확인 중 화면이 종료되면 카메라를 열지 않는다', () async {
    final h = _Harness();
    final permission = Completer<PermissionRequestResult>();
    await h.initialize(readPermission: () => permission.future);
    final first = h.vm.takeMedicationPhoto();
    h.dispose();
    permission.complete(PermissionRequestResult.granted);
    await first;
    expect(h.photos, 0);
  });

  test('인증 성공 시 리워드를 알린다', () async {
    final h = _Harness();
    await h.initialize();
    const result = MedicationPointResult(earnedPoints: 100, currentPoints: 700);
    h.vm.onMedicationVerified(result);
    await Future<void>.delayed(Duration.zero);
    expect(
      h.events.single,
      isA<ShowMedicationReward>().having((it) => it.result, 'result', result),
    );
  });

  test('복약 변경 신호를 받으면 카드를 다시 불러온다', () async {
    final h = _Harness();
    await h.initialize();
    final fetches = h.home.fetches;
    h.medication.changes.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(h.home.fetches, fetches + 1);
  });

  group('수명', () {
    test('처음에는 시작 조회 4개를 로딩으로 보여 준다', () {
      final h = _Harness()..open();
      expect(h.state.isUserLoading, isTrue);
      expect(h.state.isHeartRateLoading, isTrue);
      expect(h.state.isNotificationLoading, isTrue);
      expect(h.state.isSeniorCardLoading, isTrue);
    });

    test('사용자 이름과 워치 착용 상태를 반영한다', () async {
      final h = _Harness();
      h.user.result = const ApiResult.success(
        User(memberId: 1, name: '박춘자', points: 0),
      );
      await h.initialize();
      expect(h.state.name, '박춘자');
      expect(h.state.isUserLoading, isFalse);

      h.heartRate.connection.add(true);
      await Future<void>.delayed(Duration.zero);
      expect(h.state.isWearing, isTrue);
    });

    test('조회 시작 전에 폐기되면 조회하지 않는다', () async {
      final h = _Harness()..open();
      h.dispose();
      await Future<void>.delayed(Duration.zero);
      expect(h.home.fetches, 0);
    });

    test('카드 조회 중 폐기돼도 서버 걸음 수는 반영하고 상태는 쓰지 않는다', () async {
      final h = _Harness();
      h.home
        ..walk = const StepProgress(actual: 1234, goal: 5000)
        ..pending = Completer();
      await h.initialize();
      expect(h.home.fetches, 1);

      h.dispose();
      h.home.pending!.complete();
      // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
      await Future<void>.delayed(Duration.zero);
      expect(h.walk.applied.single.$1, 1234);
    });

    test('사용자·심박수·알림 조회 중 폐기되면 상태와 실패 안내를 쓰지 않는다', () async {
      final h = _Harness();
      final gate = Completer<void>();
      h.user.pending = gate;
      h.heartRate.pending = gate;
      h.notification.pending = gate;
      await h.initialize();

      h.dispose();
      gate.complete();
      // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
      await Future<void>.delayed(Duration.zero);
      expect(h.events, isEmpty);
    });

    test('인증 화면에서 돌아오기 전에 폐기되면 보상 이벤트를 보내지 않는다', () async {
      final h = _Harness();
      await h.initialize();
      h.dispose();

      // 가드가 없으면 닫힌 이벤트 stream에 보내다가 예외가 난다.
      h.vm.onMedicationVerified(
        const MedicationPointResult(earnedPoints: 10, currentPoints: 20),
      );
      expect(h.events, isEmpty);
    });

    test('알림 읽음 실패 응답 전에 폐기되면 목록을 되돌리지 않는다', () async {
      final h = _Harness();
      h.notification
        ..page = const ApiResult.success(NotificationPage(
          notifications: [
            model.Notification(
              notificationId: 1,
              category: 'GOAL',
              title: '알림',
              createdAt: '',
            ),
          ],
          hasNext: false,
        ))
        ..read = Completer();
      await h.initialize();
      expect(h.state.notifications, hasLength(1));

      final read = h.vm.markNotificationAsRead(1);
      expect(h.state.notifications, isEmpty);
      h.dispose();
      h.notification.read!.complete(const ApiResult.failure('error'));
      // 가드가 없으면 폐기된 state를 읽다가 예외가 난다.
      await read;
      expect(h.events, isEmpty);
    });

    test('다시 빌드돼도 같은 이벤트 stream을 유지하고 다시 구독한다', () async {
      final h = _Harness();
      await h.initialize();

      h.container.invalidate(homeViewModelProvider);
      h.container.read(homeViewModelProvider);
      await Future<void>.delayed(Duration.zero);
      expect(h.home.fetches, 2);
      // 처음 시작 조회의 실패 안내는 구독 전이라 빠지고, 다시 빌드한 뒤의 안내만 들어온다.
      expect(h.events.whereType<FetchUserFailure>(), hasLength(1));
    });

    testWidgets('폐기되면 타이머와 구독을 정리한다', (tester) async {
      final h = _Harness()..open();
      await tester.pump();
      expect(h.home.fetches, 1);

      h.dispose();
      // 구독이나 30초 갱신 타이머가 남아 있으면 폐기된 state를 쓰다가 예외가 난다.
      h.walk.steps.add(100);
      h.heartRate.connection.add(true);
      h.medication.changes.add(null);
      await tester.pump(const Duration(seconds: 31));
      expect(h.home.fetches, 1);
    });
  });
}
