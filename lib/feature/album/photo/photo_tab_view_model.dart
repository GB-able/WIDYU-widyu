import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/album/photo/photo_tab_ui_state.dart';

part 'photo_tab_view_model.g.dart';

@riverpod
class PhotoTabViewModel extends _$PhotoTabViewModel {
  late InfiniteScroller<Media> _scroller;

  AlbumRepository get _repository => ref.read(albumRepositoryProvider);

  @override
  PhotoTabUiState build() {
    _scroller = InfiniteScroller(
      fetch: _fetch,
      read: () => state.list,
      write: (list) => state = state.copyWith(list: list),
      mounted: () => ref.mounted,
    );
    unawaited(Future.microtask(_start));
    return PhotoTabUiState(
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

  // 썸네일은 잠금 여부만 구독하므로 다른 캐시 변경에는 다시 그려지지 않는다.
  void _onCache(AlbumCache cache) {
    if (identical(cache, state.cache)) return;
    state = state.copyWith(
      cache: cache,
      list: identical(cache.deletedIds, state.cache.deletedIds)
          ? state.list
          : state.list.removeWhere((media) => cache.isDeleted(media.postId)),
    );
  }

  Future<void> refresh() => _scroller.init();

  Future<void> loadMore() => _scroller.loadMore();

  Future<void> retry() => _scroller.retry();

  Future<InfinitePageResult<Media>> _fetch(String? cursor) async {
    final repository = _repository;
    final result = await repository.fetchMediaFeed(cursor: cursor);
    if (result case Failure(:final message)) throw Exception(message);

    final page = (result as Success<InfinitePageResult<Media>>).data;
    final cache = repository.currentCache;
    return page.copyWith(
      items:
          page.items.where((media) => !cache.isDeleted(media.postId)).toList(),
    );
  }
}
