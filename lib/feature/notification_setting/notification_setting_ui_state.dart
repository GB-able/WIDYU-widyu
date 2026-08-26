import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';

part 'notification_setting_ui_state.freezed.dart';

@freezed
abstract class NotificationSettingUiState with _$NotificationSettingUiState {
  const factory NotificationSettingUiState({
    @Default(false) bool isLoading,
    @Default([]) List<NotificationSettingUiModel> notifications,
  }) = _NotificationSettingUiState;
}
