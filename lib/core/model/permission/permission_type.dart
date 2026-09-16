/// 앱이 사용자에게 안내하고 요청하는 권한 종류.
///
/// 선언 순서가 곧 권한 안내 화면의 노출 순서(필수/선택 구획 내부)이므로 임의로 바꾸지 않는다.
/// 실제 요청 순서는 이 순서와 무관하게 `PermissionViewModel._initialRequestPermissions` 가 정한다.
/// 표시 문구와 필수/선택 분류는 화면의 관심사이므로
/// `feature/permission/permission_ui_model.dart` 의 확장에서 관리한다.
enum PermissionType {
  notification,
  alarm,
  id,
  phone,
  location,
  fitness,
  camera,
}
