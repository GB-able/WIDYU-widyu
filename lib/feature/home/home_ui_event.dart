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

class RequestCameraPermissionPermanentlyFailure extends HomeUiEvent {
  const RequestCameraPermissionPermanentlyFailure();
}

class OpenCameraFailure extends HomeUiEvent {
  const OpenCameraFailure();
}

/// 복용 인증에 성공해 포인트를 받은 경우
class VerifyMedicationSuccess extends HomeUiEvent {
  final int earnedPoint;
  final int totalPoint;

  const VerifyMedicationSuccess({
    required this.earnedPoint,
    required this.totalPoint,
  });
}

class VerifyMedicationFailure extends HomeUiEvent {
  final String message;

  const VerifyMedicationFailure(this.message);
}

/// 일정 장소 좌표가 없어 길찾기를 열 수 없는 경우
class HealthSchedulePlaceUnavailable extends HomeUiEvent {
  const HealthSchedulePlaceUnavailable();
}

/// 카카오맵 앱과 웹 모두 실행에 실패한 경우
class OpenKakaoMapFailure extends HomeUiEvent {
  const OpenKakaoMapFailure();
}
