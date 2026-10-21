import 'package:flutter/material.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';

class FeedTabViewModel extends ChangeNotifier with InfiniteScrollMixin<int> {
  FeedTabViewModel({
    required AlbumRepository repository,
    required AlbumProvider albumProvider,
  })  : _repository = repository,
        _albumProvider = albumProvider {
    _albumProvider.deletedAlbumIds.addListener(_onAlbumsDeleted);
  }

  final AlbumRepository _repository;
  final AlbumProvider _albumProvider;

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
      super.items.where((id) => _albumProvider.postOf(id) != null).toList();

  @override
  bool get isEmpty => items.isEmpty;

  void _onAlbumsDeleted() {
    _expandedFeedIds.removeWhere((id) => _albumProvider.postOf(id) == null);
    notifyListeners();
  }

  @override
  void dispose() {
    _albumProvider.deletedAlbumIds.removeListener(_onAlbumsDeleted);
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
    _albumProvider.hydrate(page.items);
    return InfinitePageResult(
      items: page.items.map((feed) => feed.albumId).toList(),
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }
}
