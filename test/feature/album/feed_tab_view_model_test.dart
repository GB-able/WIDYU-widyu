import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/feature/album/feed/feed_tab_ui_state.dart';
import 'package:widyu/feature/album/feed/feed_tab_view_model.dart';

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
  FeedTabViewModel listen() {
    container.listen(feedTabViewModelProvider, (_, __) {});
    return container.read(feedTabViewModelProvider.notifier);
  }

  FeedTabUiState state() => container.read(feedTabViewModelProvider);

  test('첫 페이지를 불러와 캐시에 반영하고 게시물 id를 채운다', () async {
    dataSource.feeds = okResponse(page([feed(1), feed(2)], next: 'c1'));
    listen();
    expect(state().list.isLoading, isTrue);

    await pumpEventQueue();
    expect(state().list.items, [1, 2]);
    expect(state().list.hasNext, isTrue);
    expect(state().cache.postOf(1), isNotNull);
  });

  test('이미 삭제된 게시물은 목록에 넣지 않는다', () async {
    await repository.deleteFeed(1);
    dataSource.feeds = okResponse(page([feed(1), feed(2)]));
    listen();
    await pumpEventQueue();
    expect(state().list.items, [2]);
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
    listen();
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['fetchFeeds']!.complete();
    await pumpEventQueue();
    expect(repository.currentCache.postOf(1), isNull);
  });

  test('새로고침 전에 보낸 요청의 응답은 캐시에 반영하지 않는다', () async {
    dataSource.feeds = okResponse(page([feed(1)]));
    dataSource.gates['fetchFeeds'] = Completer();
    final viewModel = listen();
    await pumpEventQueue();

    dataSource.feeds = okResponse(page([feed(2)]));
    unawaited(viewModel.refresh());
    dataSource.gates['fetchFeeds']!.complete();
    await pumpEventQueue();

    expect(repository.currentCache.postOf(1), isNull);
    expect(state().list.items, [2]);
  });

  test('게시물이 삭제되면 목록과 펼침 상태에서 뺀다', () async {
    dataSource.feeds = okResponse(page([feed(1), feed(2)]));
    final viewModel = listen();
    await pumpEventQueue();
    viewModel
      ..setContentExpanded(1, true)
      ..setContentExpanded(2, true);

    await viewModel.deleteFeed(1);
    await pumpEventQueue();
    expect(state().list.items, [2]);
    expect(state().expandedFeedIds, {2});
  });

  test('삭제로 목록이 비어도 다음 페이지가 있으면 이어서 불러온다', () async {
    dataSource.feeds = okResponse(page([feed(1)], next: 'c1'));
    listen();
    await pumpEventQueue();

    dataSource.feeds = okResponse(page([feed(2)]));
    await repository.deleteFeed(1);
    await pumpEventQueue();

    expect(state().list.items, [2]);
    expect(state().list.hasNext, isFalse);
  });
}
