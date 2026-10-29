import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';

class FeedTabViewModel extends ChangeNotifier with InfiniteScrollMixin<int> {
  FeedTabViewModel({required AlbumRepository repository})
      : _repository = repository,
        _cache = repository.currentCache {
    _cacheChanges = repository.cache.listen(_onCache);
  }

  final AlbumRepository _repository;
  AlbumCache _cache;
  late final StreamSubscription<AlbumCache> _cacheChanges;

  AlbumCache get cache => _cache;

  final Set<int> _expandedFeedIds = {};

  bool isContentExpanded(int albumId) => _expandedFeedIds.contains(albumId);

  void setContentExpanded(int albumId, bool expanded) {
    if (expanded) {
      _expandedFeedIds.add(albumId);
    } else {
      _expandedFeedIds.remove(albumId);
    }
    notifyListeners();
  }

  @override
  List<int> get items =>
      super.items.where((id) => _cache.postOf(id) != null).toList();

  @override
  bool get isEmpty => items.isEmpty;

  void _onCache(AlbumCache cache) {
    if (identical(cache, _cache)) return;
    final deleted = !identical(cache.deletedIds, _cache.deletedIds);
    _cache = cache;
    if (deleted) {
      _expandedFeedIds.removeWhere((id) => _cache.postOf(id) == null);
    }
    notifyListeners();
  }

  Future<void> toggleLike(int albumId) => _repository.toggleLike(albumId);

  Future<bool> deleteFeed(int albumId) => _repository.deleteFeed(albumId);

  @override
  void dispose() {
    _cacheChanges.cancel();
    super.dispose();
  }

  @override
  Future<InfinitePageResult<int>> fetch(String? cursor) async {
    final generation = requestGeneration;
    final result = await _repository.fetchFeeds(cursor: cursor);
    if (!isRequestCurrent(generation)) {
      return const InfinitePageResult(items: <int>[], nextCursor: null);
    }
    if (result case Failure(:final message)) throw Exception(message);

    final page = (result as Success<InfinitePageResult<Feed>>).data;
    _repository.hydrate(page.items);
    _onCache(_repository.currentCache);
    return InfinitePageResult(
      items: page.items.map((feed) => feed.albumId).toList(),
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }
}
