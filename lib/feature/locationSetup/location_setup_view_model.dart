import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';
import 'package:widyu/feature/locationSetup/location_setup_ui_event.dart';
import 'package:widyu/feature/locationSetup/location_setup_ui_state.dart';

typedef LocationSetupAsyncAction = Future<void> Function();
typedef BackgroundLocationReader = Future<bool> Function();
typedef LocationSettingsOpener = Future<SettingsReturnResult> Function();

class LocationSetupViewModel with ChangeNotifier {
  final AppServiceController _serviceController;
  final LocationSetupAsyncAction _start;
  final LocationSetupAsyncAction _refresh;
  final BackgroundLocationReader _isBackgroundLocationGranted;
  final Future<bool> Function() _isLocationServiceEnabled;
  final Future<PermissionSettingsResult> Function(SettingsReturnController)
      _openBackgroundSettings;
  late final LocationSettingsOpener _openLocationSettings;
  final PermissionRecoveryController _foregroundRecovery;
  final SettingsReturnController _backgroundSettingsController;
  final SettingsReturnController _locationSettingsController;

  LocationSetupUiState _uiState = const LocationSetupUiState();
  LocationSetupUiState get uiState => _uiState;

  final _uiEvent = StreamController<LocationSetupUiEvent>.broadcast();
  Stream<LocationSetupUiEvent> get uiEvent => _uiEvent.stream;

  bool _disposed = false;
  bool _initialized = false;
  bool _completed = false;

  LocationSetupViewModel({
    required AppServiceController serviceController,
    LocationSetupAsyncAction? start,
    LocationSetupAsyncAction? refresh,
    BackgroundLocationReader? isBackgroundLocationGranted,
    Future<bool> Function()? isLocationServiceEnabled,
    Future<PermissionSettingsResult> Function(SettingsReturnController)?
        openBackgroundSettings,
    LocationSettingsOpener? openLocationSettings,
    PermissionRecoveryController? foregroundRecovery,
    SettingsReturnController? backgroundSettingsController,
    SettingsReturnController? locationSettingsController,
  })  : _serviceController = serviceController,
        _start = start ?? serviceController.start,
        _refresh = refresh ?? serviceController.refresh,
        _isBackgroundLocationGranted = isBackgroundLocationGranted ??
            PermissionManager.isBackgroundLocationGranted,
        _isLocationServiceEnabled = isLocationServiceEnabled ??
            PermissionManager.isLocationServiceEnabled,
        _openBackgroundSettings = openBackgroundSettings ??
            PermissionManager.openSettingsAndRecheckBackgroundLocation,
        _foregroundRecovery =
            foregroundRecovery ?? PermissionRecoveryController(),
        _backgroundSettingsController = backgroundSettingsController ??
            SettingsReturnController(launcher: PermissionManager.openSettings),
        _locationSettingsController = locationSettingsController ??
            SettingsReturnController(
                launcher: Geolocator.openLocationSettings) {
    _openLocationSettings =
        openLocationSettings ?? _locationSettingsController.open;
  }

  Future<void> initialize() async {
    if (_disposed || _initialized) return;
    _initialized = true;
    try {
      await _start();
      if (_disposed) return;
      await _refresh();
      if (_disposed) return;
      await _readRequirements();
      if (_disposed) return;
      _navigateIfReady();
    } catch (_) {
      _emitFailure('위치 공유 상태를 확인하지 못했어요.');
    } finally {
      if (!_disposed) {
        _uiState = _uiState.copyWith(isLoading: false);
        notifyListeners();
      }
    }
  }

  Future<void> configure({required PermissionRecoveryPrompt showPrompt}) async {
    if (_disposed || _completed || _uiState.isConfiguring) return;
    _uiState = _uiState.copyWith(isConfiguring: true);
    notifyListeners();
    try {
      var openedForegroundSettings = false;
      final foreground = await _foregroundRecovery.ensurePermission(
        PermissionType.location,
        showPrompt: (type, mode) async {
          final action = await showPrompt(type, mode);
          if (mode == PermissionRecoveryMode.settings &&
              action == PermissionRecoveryAction.openSettings) {
            openedForegroundSettings = true;
          }
          return action;
        },
      );
      if (_disposed || foreground == PermissionRequestResult.canceled) return;
      if (foreground != PermissionRequestResult.granted) {
        _emitFailure('위치 권한을 허용해 주세요.');
        return;
      }

      if (openedForegroundSettings) {
        await _refreshAndRead();
        _navigateIfReady();
        return;
      }

      await _readRequirements();
      if (_disposed) return;
      if (!_uiState.hasBackgroundLocation) {
        final result =
            await _openBackgroundSettings(_backgroundSettingsController);
        if (_disposed) return;
        if (result == PermissionSettingsResult.launchFailed) {
          _emitFailure('설정 화면을 열지 못했어요.');
        }
        await _refreshAndRead();
        _navigateIfReady();
        return;
      }

      if (!_uiState.isLocationServiceEnabled) {
        final result = await _openLocationSettings();
        if (_disposed) return;
        if (result == SettingsReturnResult.launchFailed) {
          _emitFailure('위치 설정 화면을 열지 못했어요.');
        }
        await _refreshAndRead();
        _navigateIfReady();
        return;
      }

      await _refreshAndRead();
      _navigateIfReady();
    } catch (_) {
      _emitFailure('위치 공유 설정을 완료하지 못했어요.');
    } finally {
      if (!_disposed) {
        _uiState = _uiState.copyWith(isConfiguring: false);
        notifyListeners();
      }
    }
  }

  Future<void> retry() async {
    if (_disposed || _completed || _uiState.isConfiguring) return;
    _uiState = _uiState.copyWith(isConfiguring: true);
    notifyListeners();
    try {
      await _refreshAndRead();
      _navigateIfReady();
    } catch (_) {
      _emitFailure('위치 공유를 다시 시작하지 못했어요.');
    } finally {
      if (!_disposed) {
        _uiState = _uiState.copyWith(isConfiguring: false);
        notifyListeners();
      }
    }
  }

  Future<void> _readRequirements() async {
    final background = await _isBackgroundLocationGranted();
    if (_disposed) return;
    final serviceEnabled = await _isLocationServiceEnabled();
    if (_disposed) return;
    _uiState = _uiState.copyWith(
      hasBackgroundLocation: background,
      isLocationServiceEnabled: serviceEnabled,
    );
  }

  Future<void> _refreshAndRead() async {
    await _refresh();
    if (_disposed) return;
    await _readRequirements();
  }

  void _navigateIfReady() {
    final state = _serviceController.state;
    if (state?.isAvailable == true &&
        _uiState.hasBackgroundLocation &&
        _uiState.isLocationServiceEnabled &&
        !_serviceController.hasServiceError &&
        !_disposed &&
        !_completed &&
        !_uiEvent.isClosed) {
      _completed = true;
      _uiEvent.add(const LocationSetupNavigateHome());
    }
  }

  void completeLater() {
    if (_disposed || _completed || _uiEvent.isClosed) return;
    _completed = true;
    _uiEvent.add(const LocationSetupNavigateHome());
  }

  void _emitFailure(String message) {
    if (!_disposed && !_uiEvent.isClosed) {
      _uiEvent.add(LocationSetupFailure(message));
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _foregroundRecovery.dispose();
    _backgroundSettingsController.dispose();
    _locationSettingsController.dispose();
    _uiEvent.close();
    super.dispose();
  }
}
