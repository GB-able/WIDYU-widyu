import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/storage/app_preference.dart';
import 'package:widyu/core/storage/preference_key.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/feature/permission/permission_ui_event.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';

part 'permission_view_model.g.dart';

/// 상태는 권한 요청 진행 여부(isRequesting)다.
@riverpod
class PermissionViewModel extends _$PermissionViewModel {
  final _appPreference = AppPreference();
  late PermissionRecoveryController _recoveryController;
  bool _isFinished = false;

  static List<PermissionType> get requiredPermissions =>
      _visiblePermissions.where((type) => type.isRequired).toList();

  static List<PermissionType> get optionalPermissions =>
      _visiblePermissions.where((type) => !type.isRequired).toList();

  static Iterable<PermissionType> get _visiblePermissions =>
      PermissionType.values.where((type) => Platform.isAndroid || type != PermissionType.overlay);

  final _uiEvent = StreamController<PermissionUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<PermissionUiEvent> get uiEvent => _uiEvent.stream;

  @override
  bool build() {
    // autoDispose 자원이라 watch로 붙잡는다. 의존성이 없어 재빌드를 일으키지 않는다.
    _recoveryController = ref.watch(permissionRecoveryControllerProvider);
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    return false;
  }

  /// 전체 권한 안내와 별개로 최초 실행 시 실제 요청할 권한과 순서.
  /// 나머지 권한은 해당 기능을 사용할 때 요청한다.
  static final _initialRequestPermissions = [
    PermissionType.notification,
    PermissionType.alarm,
    PermissionType.overlay,
    PermissionType.location,
    if (Platform.isAndroid) PermissionType.fitness,
  ];

  Future<void> requestPermissions({required PermissionRecoveryPrompt showPrompt}) async {
    if (!ref.mounted || _isFinished || state) return;

    state = true;

    try {
      final denied = <PermissionType>[];
      final settingsLaunchFailed = <PermissionType>[];

      // 1. 알림 → 알람 → 다른 앱 위에 표시 → 위치 → 신체 활동(Android) 순서로 최초 실행에 필요한 권한만 요청한다.
      await _requestSequentially(
        _initialRequestPermissions,
        denied,
        settingsLaunchFailed,
        showPrompt,
      );
      if (!ref.mounted) return;
      WiduLog.ui.i('권한 요청 완료 denied=${denied.map((e) => e.name).toList()}');

      // 2. 거절된 권한 안내는 요청이 모두 끝난 뒤 한 번만 발행한다.
      if (denied.isNotEmpty) {
        _uiEvent.add(PermissionsDenied(List.unmodifiable(denied)));
      }
      if (settingsLaunchFailed.isNotEmpty) {
        _uiEvent.add(
          PermissionSettingsLaunchFailure(
              List.unmodifiable(settingsLaunchFailed)),
        );
      }
    } catch (e, stack) {
      WiduLog.ui.w('권한 요청 실패', error: e, stackTrace: stack);
    } finally {
      if (ref.mounted) state = false;
    }

    if (!ref.mounted) return;
    await _finish();
  }

  /// 전달받은 순서대로 하나씩 요청하고, 허용되지 않은 항목을 [denied] 에 모은다.
  Future<void> _requestSequentially(
    List<PermissionType> types,
    List<PermissionType> denied,
    List<PermissionType> settingsLaunchFailed,
    PermissionRecoveryPrompt showPrompt,
  ) async {
    for (final type in types) {
      final result = await _recoveryController.ensurePermission(
        type,
        showPrompt: showPrompt,
      );
      if (!ref.mounted) return;
      switch (result) {
        case PermissionRequestResult.granted:
        case PermissionRequestResult.unsupported:
          break;
        case PermissionRequestResult.denied:
        case PermissionRequestResult.permanentlyDenied:
        case PermissionRequestResult.restricted:
          denied.add(type);
        case PermissionRequestResult.settingsLaunchFailed:
          settingsLaunchFailed.add(type);
        case PermissionRequestResult.canceled:
          break;
      }
    }
  }

  /// 권한 플로우를 마무리하고 다음 화면으로 이동시킨다.
  /// 권한을 모두 요청했든 건너뛰었든 안내는 본 것으로 처리한다.
  Future<void> _finish() async {
    if (!ref.mounted || _isFinished) return;
    _isFinished = true;
    await _markGuideShown();
    if (!ref.mounted) return;
    _uiEvent.add(const NavigateToNext());
  }

  /// 권한 안내 화면은 앱 최초 실행 시 1회만 노출한다.
  /// 플래그는 스플래시가 아니라 권한 플로우가 실제로 끝나는 시점에 기록하므로,
  /// 사용자가 권한 화면에서 앱을 강제 종료한 경우에는 다음 실행 때 다시 안내할 수 있다.
  /// 저장 실패는 [AppPreference] 가 내부에서 삼키므로 화면 전환을 막지 않는다.
  Future<void> _markGuideShown() =>
      _appPreference.setBool(PreferenceKey.permissionGuideShown, true);
}
