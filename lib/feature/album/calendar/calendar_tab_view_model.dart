import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';

class DateFeedState {
  const DateFeedState({
    this.albumIds = const [],
    this.cursor,
    this.nextCursor,
    this.hasNext = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
  });

  final List<int> albumIds;
  final String? cursor;
  final String? nextCursor;
  final bool hasNext;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;

  DateFeedState copyWith({
    List<int>? albumIds,
    String? cursor,
    String? nextCursor,
    bool? hasNext,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
  }) {
    return DateFeedState(
      albumIds: albumIds ?? this.albumIds,
      cursor: cursor ?? this.cursor,
      nextCursor: nextCursor ?? this.nextCursor,
      hasNext: hasNext ?? this.hasNext,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
    );
  }
}

class CalendarTabViewModel extends ChangeNotifier {
  CalendarTabViewModel({
    required AlbumRepository repository,
    required AlbumProvider albumProvider,
  })  : _repository = repository,
        _albumProvider = albumProvider {
    _albumProvider.deletedAlbumIds.addListener(_onAlbumsDeleted);
  }

  final AlbumRepository _repository;
  final AlbumProvider _albumProvider;
  bool _disposed = false;
  int _calendarRequest = 0;
  final Map<DateTime, int> _feedRequests = {};

  void _onAlbumsDeleted() {
    _expandedFeedIds.removeWhere((id) => _albumProvider.postOf(id) == null);
    unawaited(loadCalendar(_focusedMonth));
  }

  @override
  void dispose() {
    _disposed = true;
    _albumProvider.deletedAlbumIds.removeListener(_onAlbumsDeleted);
    super.dispose();
  }

  DateTime _selectedDay = DateTime.now().onlyDateTime;
  DateTime _focusedMonth = DateTime.now().onlyDateTime;
  bool _isCalendarLoading = false;
  Set<int> _daysWithEvents = {};
  final Map<DateTime, DateFeedState> _feedStates = {};
  final Set<int> _expandedFeedIds = {};

  DateTime get selectedDay => _selectedDay;
  DateTime get focusedMonth => _focusedMonth;
  bool get isCalendarLoading => _isCalendarLoading;

  DateFeedState get _selectedDayState =>
      _feedStates[_selectedDay] ?? const DateFeedState();

  List<int> get selectedDayAlbumIds => _selectedDayState.albumIds
      .where((id) => _albumProvider.postOf(id) != null)
      .toList();
  bool get isLoadingSelectedDay => _selectedDayState.isLoading;
  bool get isLoadingMoreSelectedDay => _selectedDayState.isLoadingMore;
  bool get hasErrorSelectedDay => _selectedDayState.hasError;
  bool get hasNextSelectedDay => _selectedDayState.hasNext;

  bool hasEvent(DateTime day) {
    return day.isSameMonth(_focusedMonth) && _daysWithEvents.contains(day.day);
  }

  bool isContentExpanded(int albumId) => _expandedFeedIds.contains(albumId);

  void setContentExpanded(int albumId, bool expanded) {
    if (expanded) {
      _expandedFeedIds.add(albumId);
    } else {
      _expandedFeedIds.remove(albumId);
    }
    notifyListeners();
  }

  Future<void> init() async {
    await Future.wait([loadCalendar(_focusedMonth), loadFeeds(_selectedDay)]);
  }

  Future<void> loadCalendar(DateTime month) async {
    if (_disposed) return;
    final request = ++_calendarRequest;
    _focusedMonth = month.onlyDateTime;
    _isCalendarLoading = true;
    notifyListeners();

    final result = await _repository.fetchCalendarDays(
      year: month.year,
      month: month.month,
    );
    if (_disposed || request != _calendarRequest) return;
    switch (result) {
      case Success<List<int>>(:final data):
        _daysWithEvents = data.toSet();
      case Failure(:final message):
        debugPrint('loadCalendar failed: $message');
        _daysWithEvents = {};
    }

    _isCalendarLoading = false;
    notifyListeners();
  }

  Future<void> onPageChanged(DateTime focusedDay) async {
    if (focusedDay.isSameMonth(_focusedMonth)) return;
    await loadCalendar(focusedDay);
  }

  Future<void> selectDay(DateTime day) async {
    final normalized = day.onlyDateTime;
    if (normalized.isSameDay(_selectedDay)) return;

    _selectedDay = normalized;
    notifyListeners();

    if (!_feedStates.containsKey(normalized)) {
      await loadFeeds(normalized);
    }
  }

  Future<void> loadFeeds(DateTime day) async {
    final normalized = day.onlyDateTime;
    if (_disposed) return;
    final request = (_feedRequests[normalized] ?? 0) + 1;
    _feedRequests[normalized] = request;
    _feedStates[normalized] = const DateFeedState(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchFeeds(date: normalized);
    if (_disposed ||
        _albumProvider.isDisposed ||
        request != _feedRequests[normalized]) {
      return;
    }
    switch (result) {
      case Success<InfinitePageResult<Feed>>(:final data):
        _albumProvider.hydrate(data.items);
        _feedStates[normalized] = DateFeedState(
          albumIds: data.items.map((feed) => feed.albumId).toList(),
          nextCursor: data.nextCursor,
          hasNext: data.hasNext,
        );
      case Failure(:final message):
        debugPrint('loadFeeds failed: $message');
        _feedStates[normalized] = const DateFeedState(hasError: true);
    }
    notifyListeners();
  }

  Future<void> loadMoreFeeds() async {
    final normalized = _selectedDay;
    final state = _feedStates[normalized] ?? const DateFeedState();

    if (_disposed || state.isLoading || state.isLoadingMore || !state.hasNext) {
      return;
    }
    final request = _feedRequests[normalized];

    _feedStates[normalized] = state.copyWith(
      isLoadingMore: true,
      hasError: false,
    );
    notifyListeners();

    final result = await _repository.fetchFeeds(
      cursor: state.nextCursor,
      date: normalized,
    );
    if (_disposed ||
        _albumProvider.isDisposed ||
        request != _feedRequests[normalized]) {
      return;
    }
    final current = _feedStates[normalized]!;
    switch (result) {
      case Success<InfinitePageResult<Feed>>(:final data):
        _albumProvider.hydrate(data.items);
        _feedStates[normalized] = current.copyWith(
          albumIds: {
            ...current.albumIds,
            ...data.items.map((feed) => feed.albumId),
          }.toList(),
          cursor: state.nextCursor,
          nextCursor: data.nextCursor,
          hasNext: data.hasNext,
          isLoadingMore: false,
        );
      case Failure(:final message):
        debugPrint('loadMoreFeeds failed: $message');
        _feedStates[normalized] = current.copyWith(
          isLoadingMore: false,
          hasError: true,
        );
    }
    notifyListeners();
  }

  Future<void> retry() async {
    if (selectedDayAlbumIds.isEmpty) {
      await loadFeeds(_selectedDay);
    } else {
      await loadMoreFeeds();
    }
  }
}
