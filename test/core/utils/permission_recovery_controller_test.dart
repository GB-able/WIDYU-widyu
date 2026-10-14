import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const type = PermissionType.camera;

  PermissionRecoveryController controller({
    PermissionStatusReader? statusReader,
    PermissionRequester? requester,
    PermissionRationaleReader? rationaleReader,
    PermissionSettingsRechecker? settingsRechecker,
  }) =>
      PermissionRecoveryController(
        statusReader: statusReader,
        requester: requester,
        rationaleReader: rationaleReader,
        settingsRechecker: settingsRechecker,
      );

  PermissionRecoveryPrompt action(PermissionRecoveryAction value) =>
      (_, __) async => value;

  test('허용, 지원 안 함, 제한됨 상태는 요청 없이 종료한다', () async {
    for (final expected in [
      PermissionRequestResult.granted,
      PermissionRequestResult.unsupported,
      PermissionRequestResult.restricted,
    ]) {
      var requests = 0;
      final sut = controller(
        statusReader: (_) async => expected,
        requester: (_) async {
          requests++;
          return PermissionRequestResult.granted;
        },
      );

      expect(
        await sut.ensurePermission(type,
            showPrompt: action(PermissionRecoveryAction.retry)),
        expected,
      );
      expect(requests, 0);
      sut.dispose();
    }
  });

  test('rationale에서 취소하면 재요청하지 않는다', () async {
    var requests = 0;
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.denied,
      rationaleReader: (_) async => true,
      requester: (_) async {
        requests++;
        return PermissionRequestResult.granted;
      },
    );

    expect(
      await sut.ensurePermission(type,
          showPrompt: action(PermissionRecoveryAction.cancel)),
      PermissionRequestResult.canceled,
    );
    expect(requests, 0);
    sut.dispose();
  });

  test('새 denied 요청 결과는 재요청하거나 추가 다이얼로그를 열지 않는다', () async {
    var requests = 0;
    var prompts = 0;
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.denied,
      rationaleReader: (_) async => false,
      requester: (_) async {
        requests++;
        return PermissionRequestResult.denied;
      },
    );

    expect(
      await sut.ensurePermission(type, showPrompt: (_, __) async {
        prompts++;
        return PermissionRecoveryAction.retry;
      }),
      PermissionRequestResult.denied,
    );
    expect(requests, 1);
    expect(prompts, 0);
    sut.dispose();
  });

  test('영구 거절은 확인 전 설정을 열지 않고 취소하면 canceled다', () async {
    var settingsCalls = 0;
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
      settingsRechecker: (_, __) async {
        settingsCalls++;
        return PermissionSettingsResult.granted;
      },
    );

    expect(
      await sut.ensurePermission(type,
          showPrompt: action(PermissionRecoveryAction.cancel)),
      PermissionRequestResult.canceled,
    );
    expect(settingsCalls, 0);
    sut.dispose();
  });

  test('요청 뒤 영구 거절에서 취소하면 설정은 열지 않는다', () async {
    var requests = 0;
    var settingsCalls = 0;
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.denied,
      rationaleReader: (_) async => false,
      requester: (_) async {
        requests++;
        return PermissionRequestResult.permanentlyDenied;
      },
      settingsRechecker: (_, __) async {
        settingsCalls++;
        return PermissionSettingsResult.granted;
      },
    );

    expect(
      await sut.ensurePermission(type,
          showPrompt: action(PermissionRecoveryAction.cancel)),
      PermissionRequestResult.canceled,
    );
    expect(requests, 1);
    expect(settingsCalls, 0);
    sut.dispose();
  });

  test('설정 복귀 결과를 granted와 denied로 전달한다', () async {
    for (final settingsResult in [
      PermissionSettingsResult.granted,
      PermissionSettingsResult.denied,
    ]) {
      final sut = controller(
        statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
        settingsRechecker: (_, __) async => settingsResult,
      );
      var prompts = 0;
      expect(
        await sut.ensurePermission(
          type,
          showPrompt: (_, __) async {
            prompts++;
            return PermissionRecoveryAction.openSettings;
          },
        ),
        settingsResult == PermissionSettingsResult.granted
            ? PermissionRequestResult.granted
            : PermissionRequestResult.denied,
      );
      expect(prompts, 1);
      sut.dispose();
    }
  });

  test('설정 실행 실패를 별도 결과로 전달한다', () async {
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
      settingsRechecker: (_, __) async => PermissionSettingsResult.launchFailed,
    );

    expect(
      await sut.ensurePermission(
        type,
        showPrompt: action(PermissionRecoveryAction.openSettings),
      ),
      PermissionRequestResult.settingsLaunchFailed,
    );
    sut.dispose();
  });

  test('대기 중인 다이얼로그 dispose는 즉시 canceled로 끝낸다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final sut = controller(
      statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
    );
    final result =
        sut.ensurePermission(type, showPrompt: (_, __) => prompt.future);
    await Future<void>.delayed(Duration.zero);

    sut.dispose();
    expect(await result, PermissionRequestResult.canceled);
    prompt.complete(PermissionRecoveryAction.openSettings);
  });

  test('진행 중인 다른 권한 요청은 canceled로 거절한다', () async {
    final status = Completer<PermissionRequestResult>();
    final sut = controller(statusReader: (_) => status.future);
    final first = sut.ensurePermission(type,
        showPrompt: action(PermissionRecoveryAction.retry));

    expect(
      await sut.ensurePermission(
        PermissionType.location,
        showPrompt: action(PermissionRecoveryAction.retry),
      ),
      PermissionRequestResult.canceled,
    );
    status.complete(PermissionRequestResult.granted);
    expect(await first, PermissionRequestResult.granted);
    sut.dispose();
  });

  test('notification 상태도 restricted와 permanentlyDenied를 구분한다', () {
    expect(
      PermissionManager.mapStatus(PermissionStatus.restricted),
      PermissionRequestResult.restricted,
    );
    expect(
      PermissionManager.mapStatus(PermissionStatus.permanentlyDenied),
      PermissionRequestResult.permanentlyDenied,
    );
  });

  test('API 32에서 꺼진 notification은 영구 거절이고 API 33은 denied다', () async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      PermissionManager.permissionPlatformChannel,
      (call) async {
        expect(call.method, 'getAndroidSdkInt');
        return 32;
      },
    );

    final sdk32 = await PermissionManager.androidSdkInt();
    expect(
      PermissionManager.mapNotificationStatus(
        PermissionStatus.denied,
        androidSdkInt: sdk32,
      ),
      PermissionRequestResult.permanentlyDenied,
    );
    expect(
      PermissionManager.mapNotificationStatus(
        PermissionStatus.denied,
        androidSdkInt: 33,
      ),
      PermissionRequestResult.denied,
    );
    expect(
      PermissionManager.mapNotificationStatus(
        PermissionStatus.denied,
        androidSdkInt: null,
      ),
      PermissionRequestResult.denied,
    );
    messenger.setMockMethodCallHandler(
      PermissionManager.permissionPlatformChannel,
      null,
    );
  });
}
