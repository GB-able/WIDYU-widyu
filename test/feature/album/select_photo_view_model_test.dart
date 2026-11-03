import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:widyu/feature/album/select_photo/select_photo_ui_state.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

// ViewModel이 권한·사진 플러그인을 직접 부르므로 플랫폼 채널 응답을 흉내 낸다.
const _permissionChannel =
    MethodChannel('flutter.baseflow.com/permissions/methods');
const _photoChannel = MethodChannel('com.fluttercandies/photo_manager');

AssetEntity _asset(String id) =>
    AssetEntity(id: id, typeInt: AssetType.image.index, width: 1, height: 1);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<String> calls;
  late Completer<void>? cameraGate;
  late Completer<void>? photoGate;
  late PermissionState photoPermission;
  late Completer<void>? pageGate;
  late ProviderContainer container;

  setUp(() {
    calls = [];
    cameraGate = null;
    photoGate = null;
    photoPermission = PermissionState.denied;
    pageGate = null;
    messenger.setMockMethodCallHandler(_permissionChannel, (call) async {
      calls.add(call.method);
      await cameraGate?.future;
      return PermissionStatus.denied.index;
    });
    messenger.setMockMethodCallHandler(_photoChannel, (call) async {
      calls.add(call.method);
      switch (call.method) {
        case 'getAssetPathList':
          return {
            'data': [
              {'id': 'all', 'name': '최근 항목', 'isAll': true, 'assetCount': 1},
            ],
          };
        case 'getAssetCountFromPath':
          return 1;
        case 'getAssetListPaged':
          await pageGate?.future;
          return {'data': <Map<String, dynamic>>[]};
      }
      await photoGate?.future;
      return photoPermission.index;
    });
    container = ProviderContainer.test();
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_permissionChannel, null);
    messenger.setMockMethodCallHandler(_photoChannel, null);
  });

  // 첫 listen에서 build()가 실행되고 권한 확인은 다음 microtask에 시작한다.
  SelectPhotoViewModel listen() {
    container.listen(selectPhotoViewModelProvider, (_, __) {});
    return container.read(selectPhotoViewModelProvider.notifier);
  }

  SelectPhotoUiState state() => container.read(selectPhotoViewModelProvider);

  test('사진 권한이 없으면 권한만 확인하고 목록을 불러오지 않는다', () async {
    listen();
    expect(state().photoPermission, isNull);

    await pumpEventQueue();
    expect(calls, ['checkPermissionStatus', 'requestPermissionExtend']);
    expect(state().cameraPermission, PermissionStatus.denied);
    expect(state().photoPermission, PermissionState.denied);
    expect(state().hasPhotoPermission, isFalse);
  });

  test('권한 확인 전에 폐기되면 권한을 확인하지 않는다', () async {
    listen();
    container.dispose();
    await pumpEventQueue();
    expect(calls, isEmpty);
  });

  test('카메라 권한 확인 중 폐기되면 상태를 쓰지 않고 사진 권한도 묻지 않는다', () async {
    cameraGate = Completer();
    listen();
    await pumpEventQueue();
    expect(calls, ['checkPermissionStatus']);

    container.dispose();
    cameraGate!.complete();
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    await pumpEventQueue();
    expect(calls, ['checkPermissionStatus']);
  });

  test('사진 권한 확인 중 폐기되면 상태를 쓰지 않는다', () async {
    photoGate = Completer();
    listen();
    await pumpEventQueue();
    expect(calls.last, 'requestPermissionExtend');

    container.dispose();
    photoGate!.complete();
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    await pumpEventQueue();
  });

  test('사진 목록 페이지를 불러오는 중 폐기되면 상태를 쓰지 않는다', () async {
    photoPermission = PermissionState.authorized;
    pageGate = Completer();
    listen();
    await pumpEventQueue();
    expect(calls.last, 'getAssetListPaged');
    expect(state().loadingFilters, {PhotoFilter.all});

    container.dispose();
    pageGate!.complete();
    // finally의 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    // try 안의 가드는 빠져도 catch가 예외를 잡아 기록만 하므로 이 테스트로 드러나지 않는다.
    await pumpEventQueue();
  });

  test('선택 순서를 매기고, 다시 누르면 빼고 순서를 당긴다', () async {
    final viewModel = listen();
    await pumpEventQueue();
    final first = _asset('1');
    final second = _asset('2');

    viewModel
      ..toggleSelection(first)
      ..toggleSelection(second);
    expect(state().selectOrder(first), 1);
    expect(state().selectOrder(second), 2);

    viewModel.toggleSelection(first);
    expect(state().selectOrder(first), isNull);
    expect(state().selectOrder(second), 1);
    expect(state().selected, [second]);
  });
}
