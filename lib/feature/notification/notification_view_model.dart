import 'package:flutter/material.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/model/notification/notification_group.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_ui_state.dart';

class NotificationViewModel extends ChangeNotifier
    with InfiniteScrollMixin<NotificationItemUiModel> {
  NotificationViewModel() {
    load();
  }

  NotificationUiState _uiState = const NotificationUiState();
  NotificationUiState get uiState => _uiState;

  late List<NotificationItemUiModel> _mockItems = _buildMockItems();

  Future<void> load() async {
    _uiState = _uiState.copyWith(counts: _countsOf(_mockItems));
    notifyListeners();
    await init();
  }

  Future<void> select(NotificationFilter filter) async {
    if (_uiState.filter == filter) return;

    _uiState = _uiState.copyWith(filter: filter);
    notifyListeners();
    await init();
  }

  void read(NotificationItemUiModel notification) {
    if (notification.isRead) return;

    _mockItems = [
      for (final item in _mockItems)
        item.notificationId == notification.notificationId
            ? item.copyWith(isRead: true)
            : item,
    ];
    _uiState = _uiState.copyWith(counts: _countsOf(_mockItems));
    init();
  }

  @override
  Future<InfinitePageResult<NotificationItemUiModel>> fetch(
      String? cursor) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final filter = _uiState.filter;
    final filtered = _mockItems.where((item) {
      if (filter.isUnreadOnly) return !item.isRead;
      if (filter.group != null) return item.group == filter.group;
      return true;
    }).toList();

    return InfinitePageResult(items: filtered, nextCursor: null);
  }

  Map<NotificationFilter, int> _countsOf(List<NotificationItemUiModel> items) {
    return {
      NotificationFilter.all: items.length,
      NotificationFilter.unread: items.where((e) => !e.isRead).length,
      for (final filter in NotificationFilter.values)
        if (filter.group != null)
          filter: items.where((e) => e.group == filter.group).length,
    };
  }

  List<NotificationItemUiModel> _buildMockItems() {
    final now = DateTime.now();

    return [
      NotificationItemUiModel(
        notificationId: 1,
        group: NotificationGroup.album,
        title: '부모님 님이 올려두신 게시물을 모두 읽었어요!',
        content: '새로운 게시물을 업로드해 주세요.',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 1)),
      ),
      NotificationItemUiModel(
        notificationId: 2,
        group: NotificationGroup.album,
        title: '오일남 님이 게시물에 좋아요를 눌렀어요.',
        content: '',
        isRead: true,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      NotificationItemUiModel(
        notificationId: 3,
        group: NotificationGroup.home,
        title: '송애순 님의 심박수가 높아졌어요!',
        content: '심박수를 확인하고 연락해보세요.',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationItemUiModel(
        notificationId: 4,
        group: NotificationGroup.album,
        title: '김예은 님, 4일 간 소식이 뜸했어요.',
        content: '가족에게 근황을 전하는 건 어떠세요?',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      NotificationItemUiModel(
        notificationId: 5,
        group: NotificationGroup.goal,
        title: '송애순 님이 약을 복용했어요!',
        content: '오늘의 복약 현황을 확인해보세요.',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      NotificationItemUiModel(
        notificationId: 6,
        group: NotificationGroup.etc,
        title: '오일남 님이 새로운 게시물을 잠금 해제했어요.',
        content: '',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 11)),
      ),
    ];
  }
}
