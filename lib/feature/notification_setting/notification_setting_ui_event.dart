sealed class NotificationSettingUiEvent {
  const NotificationSettingUiEvent();
}

class FetchNotificationSettingFailure extends NotificationSettingUiEvent {
  const FetchNotificationSettingFailure();
}

class UpdateNotificationSettingFailure extends NotificationSettingUiEvent {
  const UpdateNotificationSettingFailure();
}
