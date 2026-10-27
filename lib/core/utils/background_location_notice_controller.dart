import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';

typedef BackgroundLocationPermissionReader = Future<bool> Function();
typedef BackgroundLocationSettingsRechecker = Future<PermissionSettingsResult>
    Function(SettingsReturnController controller);

/// 앱이 실행된 동안 위치 '항상 허용' 안내를 한 번만 노출한다.
///
/// 선행 조건: 포그라운드 위치가 허용된 뒤에만 안내한다. (Android 가이드)
/// 포그라운드가 아직 허용되지 않았다면 1회 노출 권한을 소비하지 않고 false를
/// 반환하므로 다음 진입에서 다시 평가된다.
///
/// 첫 상태 확인 결과가 허용이면 이후에 권한이 철회되어도 안내를 다시 띄우지
/// 않는다. 안내 여부는 앱 재시작 시에만 초기화된다.
class BackgroundLocationNoticeController {
  BackgroundLocationNoticeController({
    BackgroundLocationPermissionReader? permissionReader,
    BackgroundLocationPermissionReader? foregroundPermissionReader,
    SettingsReturnController? settingsController,
    BackgroundLocationSettingsRechecker? settingsRechecker,
  })  : _permissionReader =
            permissionReader ?? PermissionManager.isBackgroundLocationGranted,
        _foregroundPermissionReader = foregroundPermissionReader ??
            (() => PermissionManager.isGranted(PermissionType.location)),
        _settingsController = settingsController ??
            SettingsReturnController(launcher: PermissionManager.openSettings),
        _settingsRechecker = settingsRechecker ??
            PermissionManager.openSettingsAndRecheckBackgroundLocation;

  final BackgroundLocationPermissionReader _permissionReader;
  final BackgroundLocationPermissionReader _foregroundPermissionReader;
  final SettingsReturnController _settingsController;
  final BackgroundLocationSettingsRechecker _settingsRechecker;

  bool _claimed = false;
  bool _disposed = false;

  /// 안내를 보여야 하면 true를 반환한다.
  /// 포그라운드 위치가 허용되지 않았거나 조회에 실패하면 1회 노출 권한을
  /// 소비하지 않고 false를 반환한다.
  /// 포그라운드 조건을 통과하면 '항상 허용' 조회 await 전에 플래그를 소비해
  /// 화면 재빌드나 중복 진입에서도 한 번만 평가한다.
  Future<bool> claimNoticeIfNeeded() async {
    if (_claimed || _disposed) return false;
    try {
      if (!await _foregroundPermissionReader()) return false;
      if (_claimed || _disposed) return false;
      _claimed = true;
      final granted = await _permissionReader();
      return !_disposed && !granted;
    } catch (_) {
      return false;
    }
  }

  Future<PermissionSettingsResult> openSettingsAndRecheck() async {
    if (_disposed) return PermissionSettingsResult.canceled;
    final result = await _settingsRechecker(_settingsController);
    return _disposed ? PermissionSettingsResult.canceled : result;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _settingsController.dispose();
  }
}
