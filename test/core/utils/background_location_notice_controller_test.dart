import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  BackgroundLocationNoticeController controller({
    BackgroundLocationPermissionReader? permissionReader,
    SettingsReturnController? settingsController,
    BackgroundLocationSettingsRechecker? settingsRechecker,
  }) =>
      BackgroundLocationNoticeController(
        permissionReader: permissionReader,
        settingsController: settingsController,
        settingsRechecker: settingsRechecker,
      );

  test('앱 실행 중에는 위치 항상 허용 여부를 한 번만 평가한다', () async {
    final permission = Completer<bool>();
    var reads = 0;
    final sut = controller(permissionReader: () {
      reads++;
      return permission.future;
    });

    final first = sut.claimNoticeIfNeeded();
    final second = sut.claimNoticeIfNeeded();
    expect(reads, 1);
    expect(await second, isFalse);

    permission.complete(false);
    expect(await first, isTrue);
    expect(await sut.claimNoticeIfNeeded(), isFalse);
    sut.dispose();
  });

  test('첫 평가에서 항상 허용이면 이후 철회돼도 안내하지 않는다', () async {
    var granted = true;
    final sut = controller(permissionReader: () async => granted);

    expect(await sut.claimNoticeIfNeeded(), isFalse);
    granted = false;
    expect(await sut.claimNoticeIfNeeded(), isFalse);
    sut.dispose();
  });

  test('권한 상태 조회 실패와 dispose는 안내하지 않는다', () async {
    final failing = controller(
      permissionReader: () => Future<bool>.error(StateError('failed')),
    );
    expect(await failing.claimNoticeIfNeeded(), isFalse);
    failing.dispose();

    final pending = Completer<bool>();
    final disposed = controller(permissionReader: () => pending.future);
    final result = disposed.claimNoticeIfNeeded();
    disposed.dispose();
    pending.complete(false);
    expect(await result, isFalse);
  });

  test('설정 복귀 확인은 전용 SettingsReturnController에 위임한다', () async {
    final settingsController =
        SettingsReturnController(launcher: () async => false);
    SettingsReturnController? passedController;
    final sut = controller(
      settingsController: settingsController,
      settingsRechecker: (controller) async {
        passedController = controller;
        return PermissionSettingsResult.granted;
      },
    );

    expect(
      await sut.openSettingsAndRecheck(),
      PermissionSettingsResult.granted,
    );
    expect(passedController, same(settingsController));
    sut.dispose();
  });

  test('dispose 뒤 설정 복귀 결과는 canceled로 처리한다', () async {
    final result = Completer<PermissionSettingsResult>();
    final sut = controller(settingsRechecker: (_) => result.future);
    final recheck = sut.openSettingsAndRecheck();
    sut.dispose();
    result.complete(PermissionSettingsResult.granted);

    expect(await recheck, PermissionSettingsResult.canceled);
  });
}
