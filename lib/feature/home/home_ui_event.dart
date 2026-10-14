sealed class HomeUiEvent {
  const HomeUiEvent();
}

class FetchHeartRateFailure extends HomeUiEvent {
  const FetchHeartRateFailure();
}

class FetchNotificationFailure extends HomeUiEvent {
  const FetchNotificationFailure();
}

/// 알림 읽음 처리에 실패해 목록을 원래대로 되돌린 경우
class MarkNotificationAsReadFailure extends HomeUiEvent {
  const MarkNotificationAsReadFailure();
}

class FetchUserFailure extends HomeUiEvent {
  const FetchUserFailure();
}

class FetchSeniorCardFailure extends HomeUiEvent {
  const FetchSeniorCardFailure();
}

class RequestCameraPermissionFailure extends HomeUiEvent {
  const RequestCameraPermissionFailure();
}

class CameraPermissionSettingsGranted extends HomeUiEvent {
  const CameraPermissionSettingsGranted();
}

class CameraPermissionSettingsDenied extends HomeUiEvent {
  const CameraPermissionSettingsDenied();
}

class CameraPermissionSettingsLaunchFailure extends HomeUiEvent {
  const CameraPermissionSettingsLaunchFailure();
}

/// 카메라 권한이 준비되어 약 촬영 화면으로 이동해야 하는 경우
class NavigateToMedicationCamera extends HomeUiEvent {
  final int scheduleId;

  /// 이번 회차에 복용할 약 개수
  final int? doseCount;

  const NavigateToMedicationCamera(this.scheduleId, {this.doseCount});
}

/// 약 복용 인증에 성공해 리워드를 보여줘야 하는 경우
class ShowMedicationReward extends HomeUiEvent {
  final int earnedPoints;
  final int currentPoints;

  const ShowMedicationReward({
    required this.earnedPoints,
    required this.currentPoints,
  });
}

class VerifyMedicationFailure extends HomeUiEvent {
  const VerifyMedicationFailure();
}

/// 복용 일정 ID가 없어 인증할 수 없는 경우
class MedicationScheduleUnavailable extends HomeUiEvent {
  const MedicationScheduleUnavailable();
}

/// 일정 장소 좌표가 없어 길찾기를 열 수 없는 경우
class HealthSchedulePlaceUnavailable extends HomeUiEvent {
  const HealthSchedulePlaceUnavailable();
}

/// 카카오맵 앱과 웹 모두 실행에 실패한 경우
class OpenKakaoMapFailure extends HomeUiEvent {
  const OpenKakaoMapFailure();
}

class LocationPermissionUnavailable extends HomeUiEvent {
  const LocationPermissionUnavailable();
}

class LocationPermissionSettingsLaunchFailure extends HomeUiEvent {
  const LocationPermissionSettingsLaunchFailure();
}

/// 위치 '항상 허용' 안내를 노출해야 하는 경우
class ShowBackgroundLocationNotice extends HomeUiEvent {
  const ShowBackgroundLocationNotice();
}

/// 위치 '항상 허용' 안내에서 설정 화면을 열지 못한 경우
class BackgroundLocationSettingsLaunchFailure extends HomeUiEvent {
  const BackgroundLocationSettingsLaunchFailure();
}
