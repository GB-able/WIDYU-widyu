import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';

part 'notification_ui_state.freezed.dart';

@freezed
abstract class NotificationUiState with _$NotificationUiState {
  const factory NotificationUiState({
    @Default(false) bool isLoading,
    @Default([]) List<NotificationUiModel> notifications,
  }) = _NotificationUiState;
}
