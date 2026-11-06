import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_ui_state.dart';

part 'calendar_tab_view_model.g.dart';

@riverpod
class CalendarTabViewModel extends _$CalendarTabViewModel {
  int _calendarRequest = 0;
  final Map<DateTime, int> _feedRequests = {};

  AlbumRepository get _repository => ref.read(albumRepositoryProvider);

  @override
  CalendarTabUiState build() {
    final today = DateTime.now().onlyDateTime;
    listenSelf((_, next) {
      if (_isEmptyWithNext(next)) {
        unawaited(Future.microtask(_loadMoreIfEmpty));
      }
    });
    unawaited(Future.microtask(_start));
    return CalendarTabUiState(
      selectedDay: today,
      focusedMonth: today,
      isCalendarLoading: true,
      feedStates: {today: const DateFeedState(isLoading: true)},
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
      feedStates: {
        for (final MapEntry(:key, :value) in state.feedStates.entries)
          key: value.copyWith(albumIds: value.albumIds.where(exists).toList()),
      },
      expandedFeedIds: state.expandedFeedIds.where(exists).toSet(),
    );
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

  void _setFeedState(DateTime day, DateFeedState feedState) {
    state = state.copyWith(feedStates: {...state.feedStates, day: feedState});
  }

  // 조회 결과를 캐시에 반영하고, 캐시에 남은 게시물 id만 돌려준다.
  List<int> _hydrate(AlbumRepository repository, List<Feed> feeds) {
    repository.hydrate(feeds);
    final cache = repository.currentCache;
    _onCache(cache);
    return [
      for (final feed in feeds)
        if (cache.postOf(feed.albumId) != null) feed.albumId,
    ];
  }

  Future<void> loadFeeds(DateTime day) async {
    final normalized = day.onlyDateTime;
    if (!ref.mounted) return;
    final repository = _repository;
    final request = (_feedRequests[normalized] ?? 0) + 1;
    _feedRequests[normalized] = request;
    _setFeedState(normalized, const DateFeedState(isLoading: true));

    final result = await repository.fetchFeeds(date: normalized);
    if (!ref.mounted ||
        repository.isDisposed ||
        request != _feedRequests[normalized]) {
      return;
    }
    switch (result) {
      case Success<InfinitePageResult<Feed>>(:final data):
        _setFeedState(
          normalized,
          DateFeedState(
            albumIds: _hydrate(repository, data.items),
            nextCursor: data.nextCursor,
            hasNext: data.hasNext,
          ),
        );
      case Failure():
        _setFeedState(normalized, const DateFeedState(hasError: true));
    }
  }

  Future<void> loadMoreFeeds() async {
    if (state.selectedDayState.hasError) return;
    await _loadMoreFeeds();
  }

  Future<void> _loadMoreFeeds() async {
    if (!ref.mounted) return;
    final normalized = state.selectedDay;
    final feedState = state.feedStates[normalized] ?? const DateFeedState();

    if (feedState.isLoading || feedState.isLoadingMore || !feedState.hasNext) {
      return;
    }
    final repository = _repository;
    final request = _feedRequests[normalized];

    _setFeedState(
      normalized,
      feedState.copyWith(isLoadingMore: true, hasError: false),
    );

    final result = await repository.fetchFeeds(
      cursor: feedState.nextCursor,
      date: normalized,
    );
    if (!ref.mounted ||
        repository.isDisposed ||
        request != _feedRequests[normalized]) {
      return;
    }
    switch (result) {
      case Success<InfinitePageResult<Feed>>(:final data):
        final albumIds = _hydrate(repository, data.items);
        final current = state.feedStates[normalized]!;
        _setFeedState(
          normalized,
          current.copyWith(
            albumIds: {...current.albumIds, ...albumIds}.toList(),
            cursor: feedState.nextCursor,
            nextCursor: data.nextCursor,
            hasNext: data.hasNext,
            isLoadingMore: false,
          ),
        );
      case Failure():
        final current = state.feedStates[normalized]!;
        _setFeedState(
          normalized,
          current.copyWith(isLoadingMore: false, hasError: true),
        );
    }
  }

  bool _isEmptyWithNext(CalendarTabUiState state) {
    final day = state.feedStates[state.selectedDay];
    return day != null &&
        day.albumIds.isEmpty &&
        day.hasNext &&
        !day.isLoading;
  }

  void _loadMoreIfEmpty() {
    if (ref.mounted && _isEmptyWithNext(state)) unawaited(loadMoreFeeds());
  }

  Future<void> retry() async {
    if (state.selectedDayState.albumIds.isEmpty) {
      await loadFeeds(state.selectedDay);
    } else {
      await _loadMoreFeeds();
    }
  }
}
