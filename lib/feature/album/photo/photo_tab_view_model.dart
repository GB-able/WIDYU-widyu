import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';

class PhotoTabViewModel extends ChangeNotifier with InfiniteScrollMixin<Media> {
  PhotoTabViewModel({required AlbumRepository repository})
      : _repository = repository,
        _cache = repository.currentCache {
    _cacheChanges = repository.cache.listen(_onCache);
  }

  AlbumCache _cache;
  late final StreamSubscription<AlbumCache> _cacheChanges;

  AlbumCache get cache => _cache;

  @override
  List<Media> get items =>
      super.items.where((media) => !_cache.isDeleted(media.postId)).toList();

  @override
  bool get isEmpty => items.isEmpty;

  // 썸네일은 잠금 여부만 보여주므로 삭제·잠금 상태가 바뀔 때만 다시 그린다.
  void _onCache(AlbumCache cache) {
    final changed = !identical(cache.deletedIds, _cache.deletedIds) ||
        !identical(cache.unlockedIds, _cache.unlockedIds) ||
        !identical(cache.unlockingIds, _cache.unlockingIds);
    _cache = cache;
    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _cacheChanges.cancel();
    super.dispose();
  }

  final AlbumRepository _repository;

  @override
  Future<InfinitePageResult<Media>> fetch(String? cursor) async {
    final result = await _repository.fetchMediaFeed(cursor: cursor);
    if (result case Failure(:final message)) throw Exception(message);

    return (result as Success<InfinitePageResult<Media>>).data;
  }
}
