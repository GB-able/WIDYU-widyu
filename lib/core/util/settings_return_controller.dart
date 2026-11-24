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
  SettingsReturnController({
    required SettingsLauncher launcher,
    Duration leaveTimeout = const Duration(seconds: 5),
  })  : _launcher = launcher,
        _leaveTimeout = leaveTimeout;

  final SettingsLauncher _launcher;
  final Duration _leaveTimeout;
  Timer? _leaveTimer;
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
    _leaveTimer?.cancel();
    _leaveTimer = null;
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
      // launch 는 성공했는데 앱이 실제로 이탈하지 않으면(설정 화면이 안 뜬 경우)
      // resumed 가 영원히 오지 않아 호출자가 계속 잠기므로 이탈 여부만 제한한다.
      _leaveTimer?.cancel();
      _leaveTimer = Timer(_leaveTimeout, () {
        if (_disposed || _pending != completer || _leftApp) return;
        _complete(completer, SettingsReturnResult.launchFailed);
      });
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
    _leaveTimer?.cancel();
    _leaveTimer = null;
    WidgetsBinding.instance.removeObserver(this);
    if (!completer.isCompleted) completer.complete(result);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _leaveTimer?.cancel();
    _leaveTimer = null;
    final pending = _pending;
    if (pending != null) _complete(pending, SettingsReturnResult.canceled);
  }
}
