import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_ui_state.dart';

class NotificationViewModel extends ChangeNotifier
    with InfiniteScrollMixin<NotificationItemUiModel> {
  NotificationViewModel({required NotificationRepository repository})
      : _repository = repository {
    load();
  }

  final NotificationRepository _repository;

  NotificationUiState _uiState = const NotificationUiState();
  NotificationUiState get uiState => _uiState;

  Future<void> load() async {
    await Future.wait([_fetchCategories(), init()]);
  }

  Future<void> select(String category) async {
    if (_uiState.category == category) return;

    _uiState = _uiState.copyWith(category: category);
    notifyListeners();
    await init();
  }

  Future<void> read(NotificationItemUiModel notification) async {
    if (notification.isRead) return;

    final result =
        await _repository.readNotification(notification.notificationId);
    if (result is! Success) return;

    bool isTarget(NotificationItemUiModel item) =>
        item.notificationId == notification.notificationId;
    if (_uiState.category == 'UNREAD') {
      removeWhere(isTarget);
    } else {
      replaceWhere(isTarget, (item) => item.copyWith(isRead: true));
    }
    await _fetchCategories();
  }

  @override
  Future<InfinitePageResult<NotificationItemUiModel>> fetch(
      String? cursor) async {
    final result = await _repository.fetchNotificationPage(
      cursor == null ? null : int.tryParse(cursor),
      category: _uiState.category,
    );
    if (result case Failure(:final message)) throw Exception(message);

    final page = (result as Success<NotificationPage>).data;
    return InfinitePageResult(
      items: page.notifications.map(NotificationItemUiModel.from).toList(),
      nextCursor: page.nextCursor?.toString(),
      hasNext: page.hasNext,
    );
  }

  Future<void> _fetchCategories() async {
    final result = await _repository.fetchNotificationCategories();
    if (result is! Success) return;

    _uiState = _uiState.copyWith(
      categories: (result as Success<List<NotificationCategory>>).data,
    );
    notifyListeners();
  }
}
