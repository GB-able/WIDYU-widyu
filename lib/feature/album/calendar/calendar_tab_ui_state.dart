import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/album_cache.dart';

part 'calendar_tab_ui_state.freezed.dart';

@freezed
abstract class CalendarTabUiState with _$CalendarTabUiState {
  const CalendarTabUiState._();

  const factory CalendarTabUiState({
    required DateTime selectedDay,
    required DateTime focusedMonth,
    @Default(false) bool isCalendarLoading,
    @Default({}) Set<int> daysWithEvents,
    // 날짜별 피드. 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
    @Default({}) Map<DateTime, DateFeedState> feedStates,
    @Default({}) Set<int> expandedFeedIds,
    @Default(AlbumCache()) AlbumCache cache,
  }) = _CalendarTabUiState;

  DateFeedState get selectedDayState =>
      feedStates[selectedDay] ?? const DateFeedState();
}

@freezed
abstract class DateFeedState with _$DateFeedState {
  const factory DateFeedState({
    @Default([]) List<int> albumIds,
    String? cursor,
    String? nextCursor,
    @Default(true) bool hasNext,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasError,
  }) = _DateFeedState;
}
