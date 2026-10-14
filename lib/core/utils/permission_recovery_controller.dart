import 'dart:async';

import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';

typedef PermissionStatusReader = Future<PermissionRequestResult> Function(
  PermissionType type,
);
typedef PermissionRequester = Future<PermissionRequestResult> Function(
  PermissionType type,
);
typedef PermissionRationaleReader = Future<bool> Function(PermissionType type);
typedef PermissionSettingsRechecker = Future<PermissionSettingsResult> Function(
  PermissionType type,
  SettingsReturnController controller,
);

/// 권한 거절 상태에 따라 사용자 선택을 한 번만 처리하는 제어기.
class PermissionRecoveryController {
  PermissionRecoveryController({
    SettingsReturnController? settingsController,
    PermissionStatusReader? statusReader,
    PermissionRequester? requester,
    PermissionRationaleReader? rationaleReader,
    PermissionSettingsRechecker? settingsRechecker,
  })  : _settingsController = settingsController ??
            SettingsReturnController(launcher: PermissionManager.openSettings),
        _statusReader = statusReader ?? PermissionManager.status,
        _requester = requester ?? PermissionManager.request,
        _rationaleReader =
            rationaleReader ?? PermissionManager.shouldShowRationale,
        _settingsRechecker =
            settingsRechecker ?? PermissionManager.openSettingsAndRecheck;

  final SettingsReturnController _settingsController;
  final PermissionStatusReader _statusReader;
  final PermissionRequester _requester;
  final PermissionRationaleReader _rationaleReader;
  final PermissionSettingsRechecker _settingsRechecker;

  Completer<PermissionRequestResult>? _pending;
  bool _disposed = false;

  Future<PermissionRequestResult> ensurePermission(
    PermissionType type, {
    required PermissionRecoveryPrompt showPrompt,
  }) {
    if (_disposed || _pending != null) {
      return Future.value(PermissionRequestResult.canceled);
    }

    final completer = Completer<PermissionRequestResult>();
    _pending = completer;
    unawaited(_ensure(type, showPrompt, completer));
    return completer.future;
  }

  Future<void> _ensure(
    PermissionType type,
    PermissionRecoveryPrompt showPrompt,
    Completer<PermissionRequestResult> completer,
  ) async {
    try {
      final current = await _statusReader(type);
      if (!_isCurrent(completer)) return;
      switch (current) {
        case PermissionRequestResult.granted:
        case PermissionRequestResult.unsupported:
        case PermissionRequestResult.restricted:
          _complete(completer, current);
          return;
        case PermissionRequestResult.permanentlyDenied:
          await _openSettings(type, showPrompt, completer);
          return;
        case PermissionRequestResult.denied:
        case PermissionRequestResult.canceled:
        case PermissionRequestResult.settingsLaunchFailed:
          break;
      }

      final shouldExplain = await _rationaleReader(type);
      if (!_isCurrent(completer)) return;
      if (shouldExplain) {
        final action = await showPrompt(type, PermissionRecoveryMode.rationale);
        if (!_isCurrent(completer)) return;
        if (action != PermissionRecoveryAction.retry) {
          _complete(completer, PermissionRequestResult.canceled);
          return;
        }
      }

      final requested = await _requester(type);
      if (!_isCurrent(completer)) return;
      if (requested == PermissionRequestResult.permanentlyDenied) {
        await _openSettings(type, showPrompt, completer);
        return;
      }
      _complete(completer, requested);
    } catch (_) {
      if (_isCurrent(completer)) {
        _complete(completer, PermissionRequestResult.denied);
      }
    }
  }

  Future<void> _openSettings(
    PermissionType type,
    PermissionRecoveryPrompt showPrompt,
    Completer<PermissionRequestResult> completer,
  ) async {
    final action = await showPrompt(type, PermissionRecoveryMode.settings);
    if (!_isCurrent(completer)) return;
    if (action != PermissionRecoveryAction.openSettings) {
      _complete(completer, PermissionRequestResult.canceled);
      return;
    }

    final result = await _settingsRechecker(type, _settingsController);
    if (!_isCurrent(completer)) return;
    _complete(
      completer,
      switch (result) {
        PermissionSettingsResult.granted => PermissionRequestResult.granted,
        PermissionSettingsResult.denied => PermissionRequestResult.denied,
        PermissionSettingsResult.launchFailed =>
          PermissionRequestResult.settingsLaunchFailed,
        PermissionSettingsResult.canceled => PermissionRequestResult.canceled,
      },
    );
  }

  bool _isCurrent(Completer<PermissionRequestResult> completer) =>
      !_disposed && identical(_pending, completer);

  void _complete(
    Completer<PermissionRequestResult> completer,
    PermissionRequestResult result,
  ) {
    if (!identical(_pending, completer)) return;
    _pending = null;
    if (!completer.isCompleted) completer.complete(result);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _settingsController.dispose();
    final pending = _pending;
    if (pending != null) {
      _complete(pending, PermissionRequestResult.canceled);
    }
  }
}
