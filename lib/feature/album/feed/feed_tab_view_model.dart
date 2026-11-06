import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/album/feed/feed_tab_ui_state.dart';

part 'feed_tab_view_model.g.dart';

@riverpod
class FeedTabViewModel extends _$FeedTabViewModel {
  late InfiniteScroller<int> _scroller;

  AlbumRepository get _repository => ref.read(albumRepositoryProvider);

  @override
  FeedTabUiState build() {
    _scroller = InfiniteScroller(
      fetch: _fetch,
      read: () => state.list,
      write: (list) => state = state.copyWith(list: list),
      mounted: () => ref.mounted,
    );
    listenSelf((_, next) {
      if (_isEmptyWithNext(next.list)) {
        unawaited(Future.microtask(_loadMoreIfEmpty));
      }
    });
    unawaited(Future.microtask(_start));
    return FeedTabUiState(
      list: const InfiniteScrollState(isFetching: true),
      cache: _repository.currentCache,
    );
  }

  Future<void> _start() async {
    if (!ref.mounted) return;
    final cacheChanges = _repository.cache.listen(_onCache);
    ref.onDispose(cacheChanges.cancel);
    await _scroller.init();
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
      list: state.list.removeWhere((id) => !exists(id)),
      expandedFeedIds: state.expandedFeedIds.where(exists).toSet(),
    );
  }

  void setContentExpanded(int albumId, bool expanded) {
    state = state.copyWith(
      expandedFeedIds: expanded
          ? {...state.expandedFeedIds, albumId}
          : ({...state.expandedFeedIds}..remove(albumId)),
    );
  }

  Future<void> refresh() => _scroller.init();

  Future<void> loadMore() => _scroller.loadMore();

  bool _isEmptyWithNext(InfiniteScrollState<Object> list) =>
      list.isEmpty && list.hasNext && !list.isFetching;

  void _loadMoreIfEmpty() {
    if (ref.mounted && _isEmptyWithNext(state.list)) unawaited(loadMore());
  }

  Future<void> retry() => _scroller.retry();

  Future<void> toggleLike(int albumId) => _repository.toggleLike(albumId);

  Future<bool> deleteFeed(int albumId) => _repository.deleteFeed(albumId);

  Future<InfinitePageResult<int>> _fetch(String? cursor) async {
    final repository = _repository;
    final generation = _scroller.generation;
    final result = await repository.fetchFeeds(cursor: cursor);
    // 오래된 응답으로 공유 캐시를 덮어쓰지 않는다.
    if (!_scroller.isCurrent(generation)) {
      return const InfinitePageResult(items: <int>[], nextCursor: null);
    }
    if (result case Failure(:final message)) throw Exception(message);

    final page = (result as Success<InfinitePageResult<Feed>>).data;
    repository.hydrate(page.items);
    final cache = repository.currentCache;
    _onCache(cache);
    return InfinitePageResult(
      items: [
        for (final feed in page.items)
          if (cache.postOf(feed.albumId) != null) feed.albumId,
      ],
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }
}
