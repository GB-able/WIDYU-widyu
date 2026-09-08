/// 앱이 사용자에게 안내하고 요청하는 권한 종류.
///
/// 선언 순서가 곧 권한 안내 화면의 노출 순서이자 요청 순서이므로 임의로 바꾸지 않는다.
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
