sealed class NotificationUiEvent {
  const NotificationUiEvent();
}

class FetchNotificationFailure extends NotificationUiEvent {
  const FetchNotificationFailure();
}

class UpdateNotificationFailure extends NotificationUiEvent {
  const UpdateNotificationFailure();
}
