import 'dart:async';

import 'package:flutter/widgets.dart';

/// 시스템 설정 화면을 열고, 앱이 실제로 복귀할 때까지 기다린 결과.
enum SettingsReturnResult { returned, launchFailed, canceled }

typedef SettingsLauncher = Future<bool> Function();

/// 시스템 설정으로 이동한 뒤의 앱 생명주기를 한 번만 관찰한다.
///
/// launcher 가 성공했고 앱이 inactive/paused/hidden 상태를 거쳐 resumed 로
/// 돌아온 경우에만 [SettingsReturnResult.returned] 를 완료한다.
class SettingsReturnController with WidgetsBindingObserver {
  SettingsReturnController({required SettingsLauncher launcher})
      : _launcher = launcher;

  final SettingsLauncher _launcher;
  Completer<SettingsReturnResult>? _pending;
  bool _leftApp = false;
  bool _resumedAfterLeaving = false;
  bool _launchSucceeded = false;
  bool _disposed = false;

  bool get isDisposed => _disposed;

  Future<SettingsReturnResult> open() {
    if (_disposed) return Future.value(SettingsReturnResult.canceled);
    final pending = _pending;
    if (pending != null) return pending.future;

    final completer = Completer<SettingsReturnResult>();
    _pending = completer;
    _leftApp = false;
    _resumedAfterLeaving = false;
    _launchSucceeded = false;
    WidgetsBinding.instance.addObserver(this);
    unawaited(_launch(completer));
    return completer.future;
  }

  Future<void> _launch(Completer<SettingsReturnResult> completer) async {
    try {
      final launched = await _launcher();
      if (_disposed || _pending != completer) return;
      if (!launched) {
        _complete(completer, SettingsReturnResult.launchFailed);
        return;
      }
      _launchSucceeded = true;
      _completeIfReturned(completer);
    } catch (_) {
      if (!_disposed && _pending == completer) {
        _complete(completer, SettingsReturnResult.launchFailed);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_pending == null || _disposed) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _leftApp = true;
        _resumedAfterLeaving = false;
      case AppLifecycleState.resumed:
        if (_leftApp) _resumedAfterLeaving = true;
      case AppLifecycleState.detached:
        break;
    }
    final pending = _pending;
    if (pending != null) _completeIfReturned(pending);
  }

  void _completeIfReturned(Completer<SettingsReturnResult> completer) {
    if (_launchSucceeded && _resumedAfterLeaving) {
      _complete(completer, SettingsReturnResult.returned);
    }
  }

  void _complete(
    Completer<SettingsReturnResult> completer,
    SettingsReturnResult result,
  ) {
    if (_pending != completer) return;
    _pending = null;
    WidgetsBinding.instance.removeObserver(this);
    if (!completer.isCompleted) completer.complete(result);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    final pending = _pending;
    if (pending != null) _complete(pending, SettingsReturnResult.canceled);
  }
}
