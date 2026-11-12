import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_ui_state.dart';

part 'calendar_tab_view_model.g.dart';

@riverpod
class CalendarTabViewModel extends _$CalendarTabViewModel {
  int _calendarRequest = 0;
  final Map<DateTime, InfiniteScroller<int>> _scrollers = {};

  AlbumRepository get _repository => ref.read(albumRepositoryProvider);

  @override
  CalendarTabUiState build() {
    final today = clock.now().onlyDateTime;
    unawaited(Future.microtask(_start));
    return CalendarTabUiState(
      selectedDay: today,
      focusedMonth: today,
      isCalendarLoading: true,
      feedStates: {today: const InfiniteScrollState(isFetching: true)},
      cache: _repository.currentCache,
    );
  }

  Future<void> _start() async {
    if (!ref.mounted) return;
    final cacheChanges = _repository.cache.listen(_onCache);
    ref.onDispose(cacheChanges.cancel);
    await Future.wait([
      loadCalendar(state.focusedMonth),
      loadFeeds(state.selectedDay),
    ]);
  }

  void _onCache(AlbumCache cache) {
    if (identical(cache, state.cache)) return;
    if (identical(cache.deletedIds, state.cache.deletedIds)) {
      state = state.copyWith(cache: cache);
      return;
    }
    bool exists(int id) => cache.postOf(id) != null;
    state = state.copyWith(
      cache: cache,
      expandedFeedIds: state.expandedFeedIds.where(exists).toSet(),
    );
    for (final day in state.feedStates.keys.toList()) {
      _scrollerOf(day).update((list) => list.removeWhere((id) => !exists(id)));
    }
    unawaited(loadCalendar(state.focusedMonth));
  }

  Future<void> toggleLike(int albumId) => _repository.toggleLike(albumId);

  Future<bool> deleteFeed(int albumId) => _repository.deleteFeed(albumId);

  void setContentExpanded(int albumId, bool expanded) {
    state = state.copyWith(
      expandedFeedIds: expanded
          ? {...state.expandedFeedIds, albumId}
          : ({...state.expandedFeedIds}..remove(albumId)),
    );
  }

  Future<void> loadCalendar(DateTime month) async {
    if (!ref.mounted) return;
    final request = ++_calendarRequest;
    state = state.copyWith(
      focusedMonth: month.onlyDateTime,
      isCalendarLoading: true,
    );

    final result = await _repository.fetchCalendarDays(
      year: month.year,
      month: month.month,
    );
    if (!ref.mounted || request != _calendarRequest) return;
    state = state.copyWith(
      daysWithEvents: switch (result) {
        Success<List<int>>(:final data) => data.toSet(),
        Failure() => <int>{},
      },
      isCalendarLoading: false,
    );
  }

  Future<void> onPageChanged(DateTime focusedDay) async {
    if (focusedDay.isSameMonth(state.focusedMonth)) return;
    await loadCalendar(focusedDay);
  }

  Future<void> selectDay(DateTime day) async {
    final normalized = day.onlyDateTime;
    if (normalized.isSameDay(state.selectedDay)) return;

    state = state.copyWith(selectedDay: normalized);

    if (!state.feedStates.containsKey(normalized)) {
      await loadFeeds(normalized);
    }
  }

  InfiniteScroller<int> _scrollerOf(DateTime day) =>
      _scrollers[day] ??= InfiniteScroller(
        fetch: (cursor) => _fetch(day, cursor),
        read: () => state.feedStates[day] ?? const InfiniteScrollState(),
        write: (list) => state = state.copyWith(
          feedStates: {...state.feedStates, day: list},
        ),
        mounted: () => ref.mounted,
      );

  Future<InfinitePageResult<int>> _fetch(DateTime day, String? cursor) async {
    final repository = _repository;
    final scroller = _scrollerOf(day);
    final generation = scroller.generation;
    final result = await repository.fetchFeeds(cursor: cursor, date: day);
    // 오래된 응답으로 공유 캐시를 덮어쓰지 않는다.
    if (!scroller.isCurrent(generation) || repository.isDisposed) {
      return const InfinitePageResult(items: <int>[], nextCursor: null);
    }
    if (result case Failure(:final message)) throw Exception(message);

    final page = (result as Success<InfinitePageResult<Feed>>).data;
    repository.hydrate(page.items);
    final cache = repository.currentCache;
    _onCache(cache);
    final loaded = cursor == null
        ? const <int>{}
        : (state.feedStates[day]?.items ?? const <int>[]).toSet();
    return InfinitePageResult(
      items: [
        for (final feed in page.items)
          if (cache.postOf(feed.albumId) != null &&
              !loaded.contains(feed.albumId))
            feed.albumId,
      ],
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }

  Future<void> loadFeeds(DateTime day) => _scrollerOf(day.onlyDateTime).init();

  Future<void> loadMoreFeeds() => _scrollerOf(state.selectedDay).loadMore();

  Future<void> retry() => _scrollerOf(state.selectedDay).retry();
}
