import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_state.dart';

class NotificationSettingViewModel with ChangeNotifier {
  final NotificationRepository _repository;

  NotificationSettingUiState _uiState = const NotificationSettingUiState();
  NotificationSettingUiState get uiState => _uiState;

  final _uiEvent = StreamController<NotificationSettingUiEvent>.broadcast();
  Stream<NotificationSettingUiEvent> get uiEvent => _uiEvent.stream;

  NotificationSettingViewModel({required NotificationRepository repository})
      : _repository = repository {
    _fetchNotificationSettings();
  }

  Future<void> updateNotificationSetting(
      NotificationSettingUiModel notification) async {
    if (_uiState.isUpdating) return;

    final oldNotifications = _uiState.notifications;
    final targetIndex =
        oldNotifications.indexWhere((item) => item.group == notification.group);
    if (targetIndex == -1) return;

    final optimistic = notification.copyWith(isUpdating: true);
    final newNotifications = [...oldNotifications];
    newNotifications[targetIndex] = optimistic;
    _uiState = _uiState.copyWith(notifications: newNotifications);
    notifyListeners();

    try {
      final result = await _repository.updateNotificationSettings(
          optimistic.toDomain(_uiState.policyRevision));
      if (result is! Success<NotificationSetting>) {
        _rollback(oldNotifications);
        return;
      }
      newNotifications[targetIndex] = optimistic.copyWith(
        enabled: result.data.enabled,
        isUpdating: false,
      );
      _uiState = _uiState.copyWith(
        notifications: [...newNotifications],
        policyRevision: result.data.policyRevision,
      );
      notifyListeners();
    } catch (_) {
      _rollback(oldNotifications);
    }
  }

  void _rollback(List<NotificationSettingUiModel> notifications) {
    _uiState = _uiState.copyWith(notifications: notifications);
    _uiEvent.add(const UpdateNotificationSettingFailure());
    notifyListeners();
  }

  Future<void> _fetchNotificationSettings() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchNotificationSettings();
    if (result is Success) {
      final data = (result as Success<List<NotificationSetting>>).data;
      _uiState = _uiState.copyWith(
        notifications: data.toUiModel(),
        policyRevision: data.firstOrNull?.policyRevision ?? 0,
      );
    } else {
      _uiEvent.add(const FetchNotificationSettingFailure());
    }
    _uiState = _uiState.copyWith(isLoading: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _uiEvent.close();
    super.dispose();
  }
}
