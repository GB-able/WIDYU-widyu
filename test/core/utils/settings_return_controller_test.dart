import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  void leaveAndReturn() {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  }

  test('이탈 전 resumed는 설정 복귀로 처리하지 않는다', () async {
    final launch = Completer<bool>();
    final controller = SettingsReturnController(launcher: () => launch.future);
    final result = controller.open();
    var completed = false;
    unawaited(result.then((_) => completed = true));

    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    launch.complete(true);
    leaveAndReturn();
    expect(await result, SettingsReturnResult.returned);
    controller.dispose();
  });

  test('launcher 완료만으로는 설정 복귀를 완료하지 않는다', () async {
    final controller = SettingsReturnController(launcher: () async => true);
    final result = controller.open();
    var completed = false;
    unawaited(result.then((_) => completed = true));

    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    leaveAndReturn();
    expect(await result, SettingsReturnResult.returned);
    controller.dispose();
  });

  test('복귀가 launcher 완료보다 먼저여도 완료한다', () async {
    final launch = Completer<bool>();
    final controller = SettingsReturnController(launcher: () => launch.future);
    final result = controller.open();

    leaveAndReturn();
    launch.complete(true);

    expect(await result, SettingsReturnResult.returned);
    controller.dispose();
  });

  test('실행 false와 예외는 launchFailed를 반환한다', () async {
    final falseController =
        SettingsReturnController(launcher: () async => false);
    expect(await falseController.open(), SettingsReturnResult.launchFailed);
    falseController.dispose();

    final errorController = SettingsReturnController(
      launcher: () => Future<bool>.error(StateError('failed')),
    );
    expect(await errorController.open(), SettingsReturnResult.launchFailed);
    errorController.dispose();
  });

  test('이탈하지 않으면 timeout 후 launchFailed로 끝낸다', () async {
    const timeout = Duration(milliseconds: 10);
    final stuck = SettingsReturnController(
      launcher: () async => true,
      leaveTimeout: timeout,
    );
    expect(await stuck.open(), SettingsReturnResult.launchFailed);
    stuck.dispose();

    // 설정 화면에 오래 머무는 건 정상이므로 이탈 후에는 timeout 을 적용하지 않는다.
    final left = SettingsReturnController(
      launcher: () async => true,
      leaveTimeout: timeout,
    );
    final result = left.open();
    var completed = false;
    unawaited(result.then((_) => completed = true));
    await Future<void>.delayed(Duration.zero);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await Future<void>.delayed(timeout * 5);
    expect(completed, isFalse);

    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(await result, SettingsReturnResult.returned);
    left.dispose();
  });

  test('동시에 열면 launcher를 한 번만 호출한다', () async {
    final launch = Completer<bool>();
    var launchCount = 0;
    final controller = SettingsReturnController(launcher: () {
      launchCount++;
      return launch.future;
    });

    final first = controller.open();
    final second = controller.open();
    expect(identical(first, second), isTrue);
    expect(launchCount, 1);

    launch.complete(false);
    expect(await first, SettingsReturnResult.launchFailed);
    controller.dispose();
  });

  test('dispose는 대기 중인 작업을 canceled로 끝낸다', () async {
    final launch = Completer<bool>();
    final controller = SettingsReturnController(launcher: () => launch.future);
    final result = controller.open();

    controller.dispose();
    expect(await result, SettingsReturnResult.canceled);
    launch.complete(true);
    leaveAndReturn();
  });

  test('설정 복귀 후 새 권한 상태를 조회한다', () async {
    Future<PermissionSettingsResult> recheck(bool allowed) async {
      final controller = SettingsReturnController(launcher: () async => true);
      var readCount = 0;
      PermissionType? readType;
      final result = PermissionManager.openSettingsAndRecheck(
        PermissionType.camera,
        controller,
        isGrantedReader: (type) async {
          readCount++;
          readType = type;
          return allowed;
        },
      );
      await Future<void>.delayed(Duration.zero);
      expect(readCount, 0);
      leaveAndReturn();
      final value = await result;
      expect(readCount, 1);
      expect(readType, PermissionType.camera);
      controller.dispose();
      return value;
    }

    expect(await recheck(true), PermissionSettingsResult.granted);
    expect(await recheck(false), PermissionSettingsResult.denied);
  });

  test('실행 실패 또는 취소면 권한을 재조회하지 않는다', () async {
    var readCount = 0;
    final failed = SettingsReturnController(launcher: () async => false);
    expect(
      await PermissionManager.openSettingsAndRecheck(
        PermissionType.camera,
        failed,
        isGrantedReader: (_) async {
          readCount++;
          return true;
        },
      ),
      PermissionSettingsResult.launchFailed,
    );
    failed.dispose();

    final pending = Completer<bool>();
    final canceled = SettingsReturnController(launcher: () => pending.future);
    final result = PermissionManager.openSettingsAndRecheck(
      PermissionType.camera,
      canceled,
      isGrantedReader: (_) async {
        readCount++;
        return true;
      },
    );
    canceled.dispose();
    expect(await result, PermissionSettingsResult.canceled);
    expect(readCount, 0);
    pending.complete(true);
  });

  test('권한 재조회 중 dispose되면 canceled를 반환한다', () async {
    final read = Completer<bool>();
    final controller = SettingsReturnController(launcher: () async => true);
    final result = PermissionManager.openSettingsAndRecheck(
      PermissionType.camera,
      controller,
      isGrantedReader: (_) => read.future,
    );
    await Future<void>.delayed(Duration.zero);
    leaveAndReturn();
    await Future<void>.delayed(Duration.zero);

    controller.dispose();
    read.complete(true);

    expect(await result, PermissionSettingsResult.canceled);
  });

  test('위치 공유 설정 복귀는 포그라운드가 아닌 항상 허용을 확인한다', () async {
    const channel = MethodChannel('flutter.baseflow.com/permissions/methods');
    final queried = <int>[];
    var backgroundAllowed = false;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (call) async {
      expect(call.method, 'checkPermissionStatus');
      queried.add(call.arguments as int);
      // 포그라운드는 허용돼 있어도 항상 허용이 없으면 공유 준비는 미완료다.
      return call.arguments == Permission.locationAlways.value
          ? (backgroundAllowed
              ? PermissionStatus.granted.index
              : PermissionStatus.denied.index)
          : PermissionStatus.granted.index;
    });
    addTearDown(() =>
        binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));

    for (final allowed in [false, true]) {
      backgroundAllowed = allowed;
      queried.clear();
      final controller = SettingsReturnController(launcher: () async => true);
      final result = PermissionManager.openSettingsAndRecheckBackgroundLocation(
          controller);
      await Future<void>.delayed(Duration.zero);
      expect(queried, isEmpty);
      leaveAndReturn();
      expect(
          await result,
          allowed
              ? PermissionSettingsResult.granted
              : PermissionSettingsResult.denied);
      expect(queried, [Permission.locationAlways.value]);
      controller.dispose();
    }
  });
}
