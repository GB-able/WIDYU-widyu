import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_ui_state.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_view_model.dart';

import 'album_fakes.dart';

void main() {
  late FakeAlbumDataSource dataSource;
  late AlbumRepositoryImpl repository;
  late ProviderContainer container;

  setUp(() {
    dataSource = FakeAlbumDataSource();
    repository = fakeAlbumRepository(dataSource);
    container = ProviderContainer.test(
      overrides: [albumRepositoryProvider.overrideWithValue(repository)],
    );
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  CalendarTabViewModel listen() {
    container.listen(calendarTabViewModelProvider, (_, __) {});
    return container.read(calendarTabViewModelProvider.notifier);
  }

  CalendarTabUiState state() => container.read(calendarTabViewModelProvider);

  test('이번 달 일정과 오늘 피드를 불러온다', () async {
    dataSource.calendarDays = okResponse([1, 15]);
    dataSource.feeds = okResponse(page([feed(1), feed(2)]));
    listen();
    expect(state().isCalendarLoading, isTrue);
    expect(state().selectedDayState.isLoading, isTrue);

    await pumpEventQueue();
    expect(state().isCalendarLoading, isFalse);
    expect(state().daysWithEvents, {1, 15});
    expect(state().selectedDayState.albumIds, [1, 2]);
    expect(state().cache.postOf(1), isNotNull);
  });

  test('조회 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    await pumpEventQueue();
    expect(dataSource.calls, isEmpty);
  });

  test('조회 중 폐기되면 캐시에 반영하지 않는다', () async {
    dataSource.feeds = okResponse(page([feed(1)]));
    dataSource.gates['fetchFeeds'] = Completer();
    dataSource.gates['fetchCalendarDays'] = Completer();
    listen();
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['fetchFeeds']!.complete();
    dataSource.gates['fetchCalendarDays']!.complete();
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    await pumpEventQueue();
    expect(repository.currentCache.postOf(1), isNull);
  });

  test('게시물이 삭제되면 날짜별 목록과 펼침 상태에서 빼고 달력 일정을 다시 불러온다', () async {
    dataSource.feeds = okResponse(page([feed(1), feed(2)]));
    final viewModel = listen();
    await pumpEventQueue();
    final otherDay = DateTime.now().onlyDateTime.add(const Duration(days: 1));
    await viewModel.selectDay(otherDay);
    viewModel.setContentExpanded(1, true);
    dataSource.calls.clear();

    await viewModel.deleteFeed(1);
    await pumpEventQueue();
    expect(state().feedStates.values.map((s) => s.albumIds), [
      [2],
      [2],
    ]);
    expect(state().expandedFeedIds, isEmpty);
    expect(dataSource.calls, ['deleteFeed', 'fetchCalendarDays']);
  });

  test('이미 불러온 날짜를 다시 고르면 다시 조회하지 않는다', () async {
    final viewModel = listen();
    await pumpEventQueue();
    final today = state().selectedDay;
    final otherDay = today.add(const Duration(days: 1));

    await viewModel.selectDay(otherDay);
    await viewModel.selectDay(today);
    expect(
      dataSource.calls.where((c) => c == 'fetchFeeds'),
      hasLength(2),
    );
    expect(state().selectedDay, today);
  });

  test('다음 페이지를 이어 붙이고 겹치는 게시물은 한 번만 둔다', () async {
    dataSource.feeds = okResponse(page([feed(1), feed(2)], next: 'c1'));
    final viewModel = listen();
    await pumpEventQueue();

    dataSource.feeds = okResponse(page([feed(2), feed(3)]));
    await viewModel.loadMoreFeeds();
    expect(state().selectedDayState.albumIds, [1, 2, 3]);
    expect(state().selectedDayState.hasNext, isFalse);
    expect(state().selectedDayState.isLoadingMore, isFalse);
  });

  test('다음 페이지 요청이 실패하면 스크롤로는 다시 요청하지 않고 재시도로만 요청한다', () async {
    int requests() => dataSource.calls.where((n) => n == 'fetchFeeds').length;
    dataSource.feeds = okResponse(page([feed(1)], next: 'c1'));
    final viewModel = listen();
    await pumpEventQueue();

    dataSource.feeds = errorResponse();
    await viewModel.loadMoreFeeds();
    await viewModel.loadMoreFeeds();
    expect(requests(), 2);
    expect(state().selectedDayState.hasError, isTrue);

    dataSource.feeds = okResponse(page([feed(2)]));
    await viewModel.retry();
    expect(requests(), 3);
    expect(state().selectedDayState.albumIds, [1, 2]);
    expect(state().selectedDayState.hasError, isFalse);
  });

  test('삭제로 그날 목록이 비어도 다음 페이지가 있으면 이어서 불러온다', () async {
    dataSource.feeds = okResponse(page([feed(1)], next: 'c1'));
    listen();
    await pumpEventQueue();

    dataSource.feeds = okResponse(page([feed(2)]));
    await repository.deleteFeed(1);
    await pumpEventQueue();

    expect(state().selectedDayState.albumIds, [2]);
    expect(state().selectedDayState.hasNext, isFalse);
  });
}
