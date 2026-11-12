import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/feature/album/photo/photo_tab_ui_state.dart';
import 'package:widyu/feature/album/photo/photo_tab_view_model.dart';

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
  PhotoTabViewModel listen() {
    container.listen(photoTabViewModelProvider, (_, __) {});
    return container.read(photoTabViewModelProvider.notifier);
  }

  PhotoTabUiState state() => container.read(photoTabViewModelProvider);

  test('삭제된 게시물의 미디어를 빼고 첫 페이지를 채운다', () async {
    await repository.deleteFeed(10);
    dataSource.mediaFeed = okResponse(
      page([media(1, postId: 10), media(2, postId: 11)]),
    );
    listen();
    expect(state().list.isLoading, isTrue);

    await pumpEventQueue();
    expect(state().list.items.map((m) => m.id), [2]);
  });

  test('조회 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    await pumpEventQueue();
    expect(dataSource.calls, isEmpty);
  });

  test('조회 중 폐기되어도 예외 없이 끝난다', () async {
    dataSource.mediaFeed = okResponse(page([media(1, postId: 10)]));
    dataSource.gates['fetchMediaFeed'] = Completer();
    listen();
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['fetchMediaFeed']!.complete();
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    await pumpEventQueue();
  });

  test('게시물이 삭제되면 그 게시물의 미디어를 뺀다', () async {
    dataSource.mediaFeed = okResponse(
      page([media(1, postId: 10), media(2, postId: 11), media(3, postId: 10)]),
    );
    listen();
    await pumpEventQueue();

    await repository.deleteFeed(10);
    await pumpEventQueue();
    expect(state().list.items.map((m) => m.id), [2]);
  });

  test('삭제로 목록이 비어도 다음 페이지가 있으면 이어서 불러온다', () async {
    dataSource.mediaFeed = okResponse(page([media(1, postId: 10)], next: 'c1'));
    listen();
    await pumpEventQueue();

    dataSource.mediaFeed = okResponse(page([media(2, postId: 11)]));
    await repository.deleteFeed(10);
    await pumpEventQueue();

    expect(state().list.items.map((m) => m.id), [2]);
    expect(state().list.hasNext, isFalse);
  });
}
