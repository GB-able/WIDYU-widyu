import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_ui_state.dart';

part 'notification_view_model.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  late NotificationRepository _repository;
  late InfiniteScroller<NotificationItemUiModel> _scroller;

  @override
  NotificationUiState build() {
    _repository = ref.read(notificationRepositoryProvider);
    _scroller = InfiniteScroller(
      fetch: _fetch,
      read: () => state.list,
      write: (list) => state = state.copyWith(list: list),
      mounted: () => ref.mounted,
    );
    Future.microtask(load);
    return const NotificationUiState();
  }

  Future<void> load() async {
    await Future.wait([_fetchCategories(), _scroller.init()]);
  }

  Future<void> loadMore() => _scroller.loadMore();

  Future<void> retry() => _scroller.retry();

  Future<void> select(String category) async {
    if (state.category == category) return;

    state = state.copyWith(category: category);
    await _scroller.init();
  }

  Future<void> read(NotificationItemUiModel notification) async {
    if (notification.isRead) return;

    final result =
        await _repository.readNotification(notification.notificationId);
    if (!ref.mounted || result is! Success) return;

    bool isTarget(NotificationItemUiModel item) =>
        item.notificationId == notification.notificationId;
    state = state.copyWith(
      list: state.category == 'UNREAD'
          ? state.list.removeWhere(isTarget)
          : state.list
              .replaceWhere(isTarget, (item) => item.copyWith(isRead: true)),
    );
    await _fetchCategories();
  }

  Future<InfinitePageResult<NotificationItemUiModel>> _fetch(
      String? cursor) async {
    final result = await _repository.fetchNotificationPage(
      cursor == null ? null : int.tryParse(cursor),
      category: state.category,
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
    if (!ref.mounted || result is! Success) return;

    state = state.copyWith(
      categories: (result as Success<List<NotificationCategory>>).data,
    );
  }
}
