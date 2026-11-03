import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_state.dart';

part 'notification_setting_view_model.g.dart';

@riverpod
class NotificationSettingViewModel extends _$NotificationSettingViewModel {
  final _uiEvent = StreamController<NotificationSettingUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<NotificationSettingUiEvent> get uiEvent => _uiEvent.stream;

  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  @override
  NotificationSettingUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_fetchNotificationSettings));
    return const NotificationSettingUiState(isLoading: true);
  }

  Future<void> updateNotificationSetting(
      NotificationSettingUiModel notification) async {
    if (state.isUpdating) return;

    final oldNotifications = state.notifications;
    final targetIndex =
        oldNotifications.indexWhere((item) => item.group == notification.group);
    if (targetIndex == -1) return;

    final optimistic = notification.copyWith(isUpdating: true);
    final newNotifications = [...oldNotifications];
    newNotifications[targetIndex] = optimistic;
    state = state.copyWith(notifications: newNotifications);

    try {
      final result = await _repository.updateNotificationSettings(
          optimistic.toDomain(state.policyRevision));
      if (!ref.mounted) return;
      if (result is! Success<NotificationSetting>) {
        _rollback(oldNotifications);
        return;
      }
      WiduLog.ui.i('알림 설정 변경 성공 '
          'group=${notification.group.name} enabled=${result.data.enabled}');
      newNotifications[targetIndex] = optimistic.copyWith(
        enabled: result.data.enabled,
        isUpdating: false,
      );
      state = state.copyWith(
        notifications: [...newNotifications],
        policyRevision: result.data.policyRevision,
      );
    } catch (_) {
      if (ref.mounted) _rollback(oldNotifications);
    }
  }

  void _rollback(List<NotificationSettingUiModel> notifications) {
    state = state.copyWith(notifications: notifications);
    _uiEvent.add(const UpdateNotificationSettingFailure());
  }

  Future<void> _fetchNotificationSettings() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchNotificationSettings();
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<List<NotificationSetting>>).data;
      state = state.copyWith(
        notifications: data.toUiModel(),
        policyRevision: data.firstOrNull?.policyRevision ?? 0,
      );
    } else {
      _uiEvent.add(const FetchNotificationSettingFailure());
    }
    state = state.copyWith(isLoading: false);
  }
}
