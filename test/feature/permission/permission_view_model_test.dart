import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  }) => PermissionRecoveryController(
    settingsController: SettingsReturnController(launcher: () async => false),
    statusReader: statusReader,
    requester: requester,
    rationaleReader: rationaleReader ?? (_) async => false,
    settingsRechecker: (_, __) async => PermissionSettingsResult.canceled,
  );

  Future<PermissionRecoveryAction> cancelPrompt(
    PermissionType _,
    PermissionRecoveryMode __,
  ) async => PermissionRecoveryAction.cancel;

  test('전체 권한 목록은 유지하고 최초 요청은 알림, 알람, 위치 순서로 한정한다', () async {
    final requested = <PermissionType>[];
    final statuses = <PermissionType>[];
    final viewModel = PermissionViewModel(
      recoveryController: controller(
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
    final events = <PermissionUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    await viewModel.requestPermissions(showPrompt: cancelPrompt);
    await Future<void>.delayed(Duration.zero);

    expect(
      {...viewModel.requiredPermissions, ...viewModel.optionalPermissions},
      PermissionType.values.toSet(),
    );
    const initial = [
      PermissionType.notification,
      PermissionType.alarm,
      PermissionType.location,
    ];
    expect(requested, initial);
    expect(statuses, initial);
    expect(events.whereType<NavigateToNext>(), hasLength(1));

    await subscription.cancel();
    viewModel.dispose();
  });

  test('영구 거절 dialog가 열려 있는 동안 이동하지 않고 취소 뒤 한 번만 완료한다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final viewModel = PermissionViewModel(
      recoveryController: controller(
        statusReader: (type) async => type == PermissionType.notification
            ? PermissionRequestResult.permanentlyDenied
            : PermissionRequestResult.granted,
        requester: (_) async => PermissionRequestResult.granted,
      ),
    );
    final events = <PermissionUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

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

    await subscription.cancel();
    viewModel.dispose();
  });

  test('대기 중인 recovery를 dispose하면 이동이나 추가 상태 알림을 만들지 않는다', () async {
    final prompt = Completer<PermissionRecoveryAction>();
    final viewModel = PermissionViewModel(
      recoveryController: controller(
        statusReader: (_) async => PermissionRequestResult.permanentlyDenied,
        requester: (_) async => PermissionRequestResult.granted,
      ),
    );
    final events = <PermissionUiEvent>[];
    final subscription = viewModel.uiEvent.listen(events.add);

    final request = viewModel.requestPermissions(
      showPrompt: (_, __) => prompt.future,
    );
    await Future<void>.delayed(Duration.zero);
    viewModel.dispose();
    await request;
    prompt.complete(PermissionRecoveryAction.cancel);
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<NavigateToNext>(), isEmpty);
    await subscription.cancel();
  });
}
