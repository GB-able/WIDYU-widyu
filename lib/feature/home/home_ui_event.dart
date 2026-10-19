import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

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

class NavigateToMedicationCamera extends HomeUiEvent {
  final int scheduleId;
  final int? doseCount;

  const NavigateToMedicationCamera(this.scheduleId, {this.doseCount});
}

class MedicationScheduleUnavailable extends HomeUiEvent {
  const MedicationScheduleUnavailable();
}

class ShowMedicationReward extends HomeUiEvent {
  const ShowMedicationReward(this.result);

  final MedicationPointResult result;
}
