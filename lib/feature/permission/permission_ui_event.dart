import 'package:widyu/core/model/permission/permission_type.dart';

sealed class PermissionUiEvent {
  const PermissionUiEvent();
}

/// 권한 플로우가 끝나 다음 화면으로 이동해야 함.
class NavigateToNext extends PermissionUiEvent {
  const NavigateToNext();
}

/// 거절된 권한이 있어 기능 제한 안내가 필요함.
/// 순차 요청이 모두 끝난 뒤 한 번만 발행하여 토스트가 여러 번 쌓이지 않게 한다.
class PermissionsDenied extends PermissionUiEvent {
  final List<PermissionType> types;

  const PermissionsDenied(this.types);
}

/// 앱 설정을 열 수 없어 권한 복구를 진행하지 못한 경우.
class PermissionSettingsLaunchFailure extends PermissionUiEvent {
  final List<PermissionType> types;

  const PermissionSettingsLaunchFailure(this.types);
}
