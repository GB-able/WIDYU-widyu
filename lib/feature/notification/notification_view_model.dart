import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/feature/notification/notification_ui_event.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_ui_state.dart';

class NotificationViewModel with ChangeNotifier {
  final NotificationRepository _repository;

  NotificationUiState _uiState = const NotificationUiState();
  NotificationUiState get uiState => _uiState;

  final _uiEvent = StreamController<NotificationUiEvent>.broadcast();
  Stream<NotificationUiEvent> get uiEvent => _uiEvent.stream;

  NotificationViewModel({required NotificationRepository repository})
      : _repository = repository {
    _fetchNotificationSettings();
  }

  Future<void> updateNotificationSetting(
      NotificationUiModel notification) async {
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
      final result =
          _repository.updateNotificationSettings(optimistic.toDomain());
      if (result is Failure) {
        _rollback(oldNotifications);
        return;
      }
      newNotifications[targetIndex] = optimistic.copyWith(isUpdating: false);
      _uiState = _uiState.copyWith(notifications: [...newNotifications]);
      notifyListeners();
    } catch (_) {
      _rollback(oldNotifications);
    }
  }

  void _rollback(List<NotificationUiModel> notifications) {
    _uiState = _uiState.copyWith(notifications: notifications);
    _uiEvent.add(const UpdateNotificationFailure());
    notifyListeners();
  }

  Future<void> _fetchNotificationSettings() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchNotificationSettings();
    if (result is Success) {
      final data = (result as Success<List<NotificationSetting>>).data;
      _uiState = _uiState.copyWith(notifications: data.toUiModel());
    } else {
      _uiEvent.add(const FetchNotificationFailure());
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
