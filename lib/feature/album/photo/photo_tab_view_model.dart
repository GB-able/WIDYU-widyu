import 'package:flutter/material.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/mixins/infinite_scroll_mixin.dart';

class PhotoTabViewModel extends ChangeNotifier with InfiniteScrollMixin<Media> {
  PhotoTabViewModel({
    required AlbumRepository repository,
    required AlbumProvider albumProvider,
  })  : _repository = repository,
        _albumProvider = albumProvider {
    _albumProvider.deletedAlbumIds.addListener(_onAlbumsDeleted);
  }

  final AlbumProvider _albumProvider;

  @override
  List<Media> get items => super
      .items
      .where((media) => !_albumProvider.isDeleted(media.postId))
      .toList();

  @override
  bool get isEmpty => items.isEmpty;

  void _onAlbumsDeleted() {
    notifyListeners();
  }

  @override
  void dispose() {
    _albumProvider.deletedAlbumIds.removeListener(_onAlbumsDeleted);
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
