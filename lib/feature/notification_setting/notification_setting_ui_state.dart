import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';

part 'notification_setting_ui_state.freezed.dart';

@freezed
abstract class NotificationSettingUiState with _$NotificationSettingUiState {
  const NotificationSettingUiState._();

  const factory NotificationSettingUiState({
    @Default(false) bool isLoading,
    @Default([]) List<NotificationSettingUiModel> notifications,
    @Default(0) int policyRevision,
  }) = _NotificationSettingUiState;

  /// 변경 요청 진행 여부 (policyRevision 충돌 방지를 위해 한 번에 하나만 요청)
  bool get isUpdating => notifications.any((n) => n.isUpdating);
}
