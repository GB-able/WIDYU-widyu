import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';
import 'package:widyu/feature/permission/permission_ui_event.dart';
import 'package:widyu/feature/permission/permission_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  PermissionRecoveryController controller({
    required PermissionStatusReader statusReader,
    required PermissionRequester requester,
    PermissionRationaleReader? rationaleReader,
  }) =>
      PermissionRecoveryController(
        settingsController:
            SettingsReturnController(launcher: () async => false),
        statusReader: statusReader,
        requester: requester,
        rationaleReader: rationaleReader ?? (_) async => false,
        settingsRechecker: (_, __) async => PermissionSettingsResult.canceled,
      );

  // 실제 provider처럼 컨테이너가 폐기될 때 컨트롤러도 폐기한다.
  (ProviderContainer, PermissionViewModel, List<PermissionUiEvent>) start(
    PermissionRecoveryController recovery,
  ) {
    final container = ProviderContainer.test(overrides: [
      permissionRecoveryControllerProvider.overrideWith((ref) {
        ref.onDispose(recovery.dispose);
        return recovery;
      }),
    ]);
    container.listen(permissionViewModelProvider, (_, __) {});
    final viewModel = container.read(permissionViewModelProvider.notifier);
    final events = <PermissionUiEvent>[];
    viewModel.uiEvent.listen(events.add);
    return (container, viewModel, events);
  }

  Future<PermissionRecoveryAction> cancelPrompt(
    PermissionType _,
    PermissionRecoveryMode __,
  ) async =>
      PermissionRecoveryAction.cancel;

  test('전체 권한 목록은 유지하고 최초 요청은 알림, 알람, 다른 앱 위에 표시, 위치 순서로 한정한다', () async {
    final requested = <PermissionType>[];
    final statuses = <PermissionType>[];
    final (_, viewModel, events) = start(
      controller(
        statusReader: (type) async {
          statuses.add(type);
          return PermissionRequestResult.denied;
        },
        requester: (type) async {
          requested.add(type);
          return PermissionRequestResult.granted;
        },
      ),
    );

    await viewModel.requestPermissions(showPrompt: cancelPrompt);
    await Future<void>.delayed(Duration.zero);

    expect(
      {
        ...PermissionViewModel.requiredPermissions,
        ...PermissionViewModel.optionalPermissions,
      },
      PermissionType.values.where((type) => Platform.isAndroid || type != PermissionType.overlay).toSet(),
    );
    const initial = [
      PermissionType.notification,
      PermissionType.alarm,
      PermissionType.overlay,
      PermissionType.location,
    ];
    expect(requested, initial);
    expect(statuses, initial);
    expect(events.whereType<NavigateToNext>(), hasLength(1));
  });

  test('영구 거절 dialog가 열려 있는 동안 이동하지 않고 취소 뒤 한 번만 완료한다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final (_, viewModel, events) = start(
      controller(
        statusReader: (type) async => type == PermissionType.notification
            ? PermissionRequestResult.permanentlyDenied
            : PermissionRequestResult.granted,
        requester: (_) async => PermissionRequestResult.granted,
      ),
    );

    final request = viewModel.requestPermissions(
      showPrompt: (_, __) => prompt.future,
    );
    await Future<void>.delayed(Duration.zero);
    expect(events.whereType<NavigateToNext>(), isEmpty);

    prompt.complete(PermissionRecoveryAction.cancel);
    await request;
    await Future<void>.delayed(Duration.zero);
    expect(events.whereType<NavigateToNext>(), hasLength(1));

    await viewModel.requestPermissions(showPrompt: cancelPrompt);
    expect(events.whereType<NavigateToNext>(), hasLength(1));
  });

  test('대기 중인 recovery를 dispose하면 이동이나 추가 상태 알림을 만들지 않는다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final (container, viewModel, events) = start(
      controller(
        statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
        requester: (_) async => PermissionRequestResult.granted,
      ),
    );

    final request = viewModel.requestPermissions(
      showPrompt: (_, __) => prompt.future,
    );
    await Future<void>.delayed(Duration.zero);
    container.dispose();
    await request;
    prompt.complete(PermissionRecoveryAction.cancel);
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<NavigateToNext>(), isEmpty);
  });
}
