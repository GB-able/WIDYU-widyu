import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';
import 'package:widyu/feature/locationSetup/location_setup_ui_event.dart';
import 'package:widyu/feature/locationSetup/location_setup_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AppServiceController service(LocationServiceState state) =>
      AppServiceController(
        hasToken: () async => true,
        refreshLocationState: () async => state,
        locationStates: const Stream.empty(),
        startMonitoring: () async {},
        stopMonitoring: () async {},
        setAutoStart: (_) async {},
        startBackground: () async {},
        stopBackground: () async {},
      );

  AppServiceController failedService() => AppServiceController(
        hasToken: () async => true,
        refreshLocationState: () async =>
            LocationServiceState(serviceEnabled: true, permissionGranted: true),
        locationStates: const Stream.empty(),
        startMonitoring: () async {},
        stopMonitoring: () async {},
        setAutoStart: (_) async {},
        startBackground: () async => throw StateError('start failed'),
        stopBackground: () async {},
      );

  PermissionRecoveryController foreground(PermissionRequestResult status) =>
      PermissionRecoveryController(
        settingsController:
            SettingsReturnController(launcher: () async => false),
        statusReader: (_) async => status,
        requester: (_) async => status,
        rationaleReader: (_) async => false,
        settingsRechecker: (_, __) async => PermissionSettingsResult.canceled,
      );

  test('이미 준비된 위치 공유는 start와 refresh 뒤 홈으로 한 번 이동한다', () async {
    final controller = service(
      LocationServiceState(serviceEnabled: true, permissionGranted: true),
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => true,
      isLocationServiceEnabled: () async => true,
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.initialize();
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<LocationSetupNavigateHome>(), hasLength(1));
    expect(viewModel.uiState.isLoading, isFalse);
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('항상 허용이 없으면 foreground 뒤 background 설정만 열고 상태를 갱신한다', () async {
    var background = false;
    var backgroundSettingsOpened = 0;
    final controller = service(
      LocationServiceState(serviceEnabled: false, permissionGranted: false),
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => background,
      isLocationServiceEnabled: () async => false,
      openBackgroundSettings: (_) async {
        backgroundSettingsOpened++;
        background = true;
        return PermissionSettingsResult.granted;
      },
      openLocationSettings: () async => SettingsReturnResult.returned,
    );

    await viewModel.initialize();
    await viewModel.configure(showPrompt: _cancelPrompt);

    expect(backgroundSettingsOpened, 1);
    expect(viewModel.uiState.hasBackgroundLocation, isTrue);
    expect(viewModel.uiState.isLocationServiceEnabled, isFalse);
    controller.dispose();
    viewModel.dispose();
  });

  test('서비스 시작 실패 상태에서는 준비 완료여도 홈으로 자동 이동하지 않는다', () async {
    final controller = failedService();
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => true,
      isLocationServiceEnabled: () async => true,
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.initialize();
    await Future<void>.delayed(Duration.zero);

    expect(controller.hasServiceError, isTrue);
    expect(events.whereType<LocationSetupNavigateHome>(), isEmpty);
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('background 설정 복귀 뒤 GPS가 부족하면 같은 탭에서 GPS 설정을 열지 않는다', () async {
    var background = false;
    var gpsEnabled = false;
    var backgroundCalls = 0;
    var gpsCalls = 0;
    final controller = service(
      LocationServiceState(serviceEnabled: true, permissionGranted: true),
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => background,
      isLocationServiceEnabled: () async => gpsEnabled,
      openBackgroundSettings: (_) async {
        backgroundCalls++;
        background = true;
        return PermissionSettingsResult.granted;
      },
      openLocationSettings: () async {
        gpsCalls++;
        gpsEnabled = true;
        return SettingsReturnResult.returned;
      },
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.initialize();
    await viewModel.configure(showPrompt: _cancelPrompt);
    expect(backgroundCalls, 1);
    expect(gpsCalls, 0);
    expect(events.whereType<LocationSetupNavigateHome>(), isEmpty);

    await viewModel.configure(showPrompt: _cancelPrompt);
    await Future<void>.delayed(Duration.zero);
    expect(gpsCalls, 1);
    expect(events.whereType<LocationSetupNavigateHome>(), hasLength(1));
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('서비스 오류는 자동 이동을 막고 재시도 성공 뒤 한 번 이동한다', () async {
    var fails = true;
    final controller = AppServiceController(
      hasToken: () async => true,
      refreshLocationState: () async =>
          LocationServiceState(serviceEnabled: true, permissionGranted: true),
      locationStates: const Stream.empty(),
      startMonitoring: () async {},
      stopMonitoring: () async {},
      setAutoStart: (_) async {},
      startBackground: () async {
        if (fails) throw StateError('start failed');
      },
      stopBackground: () async {},
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => true,
      isLocationServiceEnabled: () async => true,
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.initialize();
    expect(events.whereType<LocationSetupNavigateHome>(), isEmpty);
    fails = false;
    await viewModel.retry();
    await Future<void>.delayed(Duration.zero);
    expect(events.whereType<LocationSetupNavigateHome>(), hasLength(1));
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('GPS만 부족하면 background 설정은 열지 않고 GPS 설정 뒤 홈으로 이동한다', () async {
    var gpsEnabled = false;
    var backgroundCalls = 0;
    var gpsCalls = 0;
    final controller = service(
      LocationServiceState(serviceEnabled: true, permissionGranted: true),
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.granted),
      isBackgroundLocationGranted: () async => true,
      isLocationServiceEnabled: () async => gpsEnabled,
      openBackgroundSettings: (_) async {
        backgroundCalls++;
        return PermissionSettingsResult.denied;
      },
      openLocationSettings: () async {
        gpsCalls++;
        gpsEnabled = true;
        return SettingsReturnResult.returned;
      },
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.initialize();
    await viewModel.configure(showPrompt: _cancelPrompt);
    await Future<void>.delayed(Duration.zero);

    expect(backgroundCalls, 0);
    expect(gpsCalls, 1);
    expect(events.whereType<LocationSetupNavigateHome>(), hasLength(1));
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('나중에 선택은 홈 이동 이벤트를 한 번만 보낸다', () async {
    final controller = service(
      LocationServiceState(serviceEnabled: false, permissionGranted: false),
    );
    final viewModel = LocationSetupViewModel(serviceController: controller);
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    viewModel.completeLater();
    viewModel.completeLater();
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<LocationSetupNavigateHome>(), hasLength(1));
    await subscription.cancel();
    viewModel.dispose();
    controller.dispose();
  });

  test('dispose된 setup은 대기 중 설정 결과가 돌아와도 홈으로 이동하지 않는다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final controller = service(
      LocationServiceState(serviceEnabled: false, permissionGranted: false),
    );
    final viewModel = LocationSetupViewModel(
      serviceController: controller,
      foregroundRecovery: foreground(PermissionRequestResult.permanentlyDenied),
      isBackgroundLocationGranted: () async => false,
      isLocationServiceEnabled: () async => false,
    );
    final events = <LocationSetupUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    final configure = viewModel.configure(showPrompt: (_, __) => prompt.future);
    await Future<void>.delayed(Duration.zero);
    viewModel.dispose();
    await configure;
    prompt.complete(PermissionRecoveryAction.cancel);
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<LocationSetupNavigateHome>(), isEmpty);
    await subscription.cancel();
    controller.dispose();
  });
}

Future<PermissionRecoveryAction> _cancelPrompt(
  PermissionType _,
  PermissionRecoveryMode __,
) async =>
    PermissionRecoveryAction.cancel;
