import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_view_model.dart';

class _Home extends Fake implements HomeRepository {
  @override
  Future<ApiResult<SeniorCard>> fetchSeniorCard() async =>
      const ApiResult.success(SeniorCard(
        heartRate: null,
        medicine: null,
        albums: [],
        healthSchedule: HealthSchedule(
          scheduleName: null,
          dday: null,
          scheduledAt: null,
          placeAddress: '병원',
          latitude: 37,
          longitude: 127,
        ),
        walk: null,
      ));
}

class _MyPage extends Fake implements MyPageRepository {
  @override
  Future<ApiResult<User>> fetchUser() async =>
      const ApiResult.failure('unused');
}

class _Notification extends Fake implements NotificationRepository {
  @override
  Future<ApiResult<NotificationPage>> fetchNotificationPage(
          int? cursor) async =>
      const ApiResult.failure('unused');
}

class _HeartRate extends Fake implements HeartRateRepository {
  @override
  Future<ApiResult<HeartRateResponse>> fetchHeartRate() async =>
      const ApiResult.failure('unused');

  @override
  Stream<bool> observeConnection() => const Stream.empty();
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

class _Harness {
  final location = _Location();
  final events = <HomeUiEvent>[];
  final starts = <UserLocation?>[];
  int photos = 0;
  bool disposed = false;
  late HomeViewModel vm;

  Future<void> initialize({
    PermissionRequestResult permission = PermissionRequestResult.granted,
    PermissionSettingsResult settings = PermissionSettingsResult.granted,
    Future<PermissionRequestResult> Function()? readPermission,
    Future<CameraCaptureResult> Function()? capture,
    BackgroundLocationNoticeController? noticeController,
  }) async {
    vm = HomeViewModel(
      homeRepository: _Home(),
      myPageRepository: _MyPage(),
      notificationRepository: _Notification(),
      heartRateRepository: _HeartRate(),
      locationRepository: location,
      permissionRecoveryController: PermissionRecoveryController(
        statusReader: (_) => readPermission?.call() ?? Future.value(permission),
        requester: (_) async => permission,
        rationaleReader: (_) async => false,
        settingsRechecker: (_, __) async => settings,
      ),
      noticeController: noticeController ??
          BackgroundLocationNoticeController(
            foregroundPermissionReader: () async => false,
          ),
      takePhoto: () {
        photos++;
        return capture?.call() ?? Future.value(const CameraCaptureSuccess('x'));
      },
      openRoute: ({
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
      },
    );
    await Future<void>.delayed(Duration.zero);
    final subscription = vm.uiEvent.listen(events.add);
    addTearDown(() async {
      if (!disposed) vm.dispose();
      await subscription.cancel();
    });
  }

  void dispose() {
    disposed = true;
    vm.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('카메라는 허용 시 한 번 촬영하고 성공을 알린다', () async {
    final h = _Harness();
    await h.initialize();
    await h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    expect(h.photos, 1);
    expect(h.events.single, isA<TakeMedicationPhotoSuccess>());
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

  test('중복 촬영을 막고 촬영 취소 후에는 다시 시도할 수 있다', () async {
    final h = _Harness();
    final capture = Completer<CameraCaptureResult>();
    await h.initialize(capture: () => capture.future);
    final first = h.vm.takeMedicationPhoto();
    await Future<void>.delayed(Duration.zero);
    await h.vm.takeMedicationPhoto();
    expect(h.photos, 1);
    capture.complete(const CameraCaptureCanceled());
    await first;
    await h.vm.takeMedicationPhoto();
    expect(h.photos, 2);
    expect(h.events, isEmpty);
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
}
