import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/model/album/album_stat.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  final AlbumRemoteDataSource _remoteDataSource;
  final PointRepository _pointRepository;

  AlbumRepositoryImpl({
    required AlbumRemoteDataSource remoteDataSource,
    required PointRepository pointRepository,
  })  : _remoteDataSource = remoteDataSource,
        _pointRepository = pointRepository;

  final _cacheSubject = BehaviorSubject<AlbumCache>.seeded(const AlbumCache());
  AlbumCache _cache = const AlbumCache();
  final Set<int> _pendingLikeIds = {};
  bool _isUnlockedLoaded = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _cacheSubject.close();
  }

  // 재생되는 마지막 값이 오래됐을 수 있어 받는 시점의 캐시로 다시 읽는다.
  @override
  Stream<AlbumCache> get cache => _cacheSubject.stream.map((_) => currentCache);

  @override
  AlbumCache get currentCache => _cache;

  @override
  bool get isDisposed => _disposed;

  void _emit(AlbumCache cache) {
    if (_disposed) return;
    _cache = cache;
    _cacheSubject.add(cache);
  }

  bool _canApplyRead(int albumId) =>
      !_cache.isDeleted(albumId) && !_pendingLikeIds.contains(albumId);

  @override
  Future<ApiResult<FeedDetail>> fetchFeed(int albumId) async =>
      _remoteDataSource.fetchFeed(albumId).toApiResult();

  @override
  Future<ApiResult<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  }) async =>
      _remoteDataSource.fetchFeeds(cursor: cursor, date: date).toApiResult();

  @override
  Future<ApiResult<InfinitePageResult<Media>>> fetchMediaFeed({
    String? cursor,
  }) async =>
      _remoteDataSource.fetchMediaFeed(cursor: cursor).toApiResult();

  @override
  Future<ApiResult<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  }) async =>
      _remoteDataSource
          .fetchCalendarDays(year: year, month: month)
          .toApiResult();

  @override
  void hydrate(Iterable<FeedBase> feeds) {
    if (_disposed) return;
    final posts = {..._cache.posts};
    final stats = {..._cache.stats};
    var changed = false;

    for (final feed in feeds) {
      if (!_canApplyRead(feed.albumId)) continue;
      final previous = posts[feed.albumId];
      posts[feed.albumId] = AlbumPost.fromFeed(
        feed,
        thumbnailUrls: previous?.thumbnailUrls ?? const [],
      );
      stats[feed.albumId] = AlbumStat(
        isLiked: stats[feed.albumId]?.isLiked ?? false,
        likeCount: feed.likeCount,
        commentCount: feed.commentCount,
      );
      changed = true;
    }

    if (changed) _emit(_cache.copyWith(posts: posts, stats: stats));
  }

  @override
  Future<void> loadLikedAlbumIds() async {
    if (_disposed) return;
    final result = await _remoteDataSource.fetchLikedFeeds().toApiResult();
    if (_disposed || result is! Success<List<int>>) return;

    final liked = result.data.toSet();
    final stats = {..._cache.stats};
    for (final id in {...stats.keys, ...liked}) {
      if (!_canApplyRead(id)) continue;
      stats[id] = _cache.statOf(id).copyWith(isLiked: liked.contains(id));
    }
    _emit(_cache.copyWith(stats: stats));
  }

  @override
  Future<void> ensureUnlockedLoaded() async {
    if (_isUnlockedLoaded) return;
    await loadUnlockedAlbumIds();
  }

  @override
  Future<void> loadUnlockedAlbumIds() async {
    if (_disposed) return;
    final result = await _remoteDataSource.fetchUnlockedAlbums().toApiResult();
    if (_disposed || result is! Success<List<int>>) return;

    _isUnlockedLoaded = true;
    _emit(_cache.copyWith(
      unlockedIds: result.data.where((id) => !_cache.isDeleted(id)).toSet(),
    ));
  }

  @override
  Future<void> toggleLike(int albumId) async {
    if (_disposed || _cache.isDeleted(albumId)) return;
    if (_pendingLikeIds.contains(albumId)) return;

    final before = _cache.statOf(albumId);
    final wasLiked = before.isLiked;

    _pendingLikeIds.add(albumId);
    _emit(_cache.copyWith(stats: {
      ..._cache.stats,
      albumId: before.copyWith(
        isLiked: !wasLiked,
        likeCount: wasLiked ? before.likeCount - 1 : before.likeCount + 1,
      ),
    }));

    final result = wasLiked
        ? await _remoteDataSource.unlikeFeed(albumId).toApiResult()
        : await _remoteDataSource.likeFeed(albumId).toApiResult();

    if (_disposed || _cache.isDeleted(albumId)) return;
    _pendingLikeIds.remove(albumId);

    if (result is Failure) {
      _emit(_cache.copyWith(stats: {
        ..._cache.stats,
        albumId: _cache
            .statOf(albumId)
            .copyWith(isLiked: wasLiked, likeCount: before.likeCount),
      }));
      return;
    }
    WiduLog.ui.i('${wasLiked ? '좋아요 취소' : '좋아요'} 성공 albumId=$albumId');
  }

  @override
  Future<bool> unlock(int albumId) async {
    if (_disposed || _cache.isDeleted(albumId)) return false;
    if (_cache.isUnlocked(albumId)) return true;
    if (_cache.isUnlocking(albumId)) return false;
    _emit(_cache.copyWith(unlockingIds: {..._cache.unlockingIds, albumId}));

    try {
      final result = await _remoteDataSource.unlockFeed(albumId).toApiResult();
      if (_disposed || _cache.isDeleted(albumId)) return false;

      if (result is Failure) {
        return false;
      }

      final unlockedId = (result as Success<AlbumUnlock>).data.albumId;
      WiduLog.ui.i('게시글 잠금 해제 성공 albumId=$albumId');
      _emit(_cache.copyWith(
        unlockedIds: {..._cache.unlockedIds, albumId, unlockedId},
      ));

      await _pointRepository.refresh();
      return !_disposed && !_cache.isDeleted(albumId);
    } finally {
      _emit(_cache.copyWith(
        unlockingIds: {..._cache.unlockingIds}..remove(albumId),
      ));
    }
  }

  @override
  Future<ApiResult<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  }) async =>
      _remoteDataSource
          .uploadFeed(mediaFiles: mediaFiles, content: content)
          .toApiResult();

  @override
  Future<bool> updateFeed({
    required int albumId,
    required String content,
  }) async {
    if (_disposed || _cache.isDeleted(albumId)) return false;
    final result = await _remoteDataSource
        .updateFeed(albumId: albumId, content: content)
        .toApiResult();
    if (_disposed || _cache.isDeleted(albumId)) return false;
    if (result is Failure) {
      return false;
    }
    WiduLog.ui.i('게시글 수정 성공 albumId=$albumId');
    final post = _cache.postOf(albumId);
    if (post != null) {
      _emit(_cache.copyWith(posts: {
        ..._cache.posts,
        albumId: post.copyWith(content: content),
      }));
    }
    return true;
  }

  @override
  Future<bool> deleteFeed(int albumId) async {
    if (_disposed) return false;
    if (_cache.isDeleted(albumId)) return true;
    final result = await _remoteDataSource.deleteFeed(albumId).toApiResult();

    if (result is Failure) {
      return false;
    }

    WiduLog.ui.i('게시글 삭제 성공 albumId=$albumId');
    if (_disposed) return false;
    _pendingLikeIds.remove(albumId);
    _emit(_cache.copyWith(
      posts: {..._cache.posts}..remove(albumId),
      stats: {..._cache.stats}..remove(albumId),
      unlockedIds: {..._cache.unlockedIds}..remove(albumId),
      unlockingIds: {..._cache.unlockingIds}..remove(albumId),
      deletedIds: {..._cache.deletedIds, albumId},
    ));
    return true;
  }

  @override
  void addViewer(int albumId, Member viewer) {
    if (_disposed || _cache.isDeleted(albumId)) return;
    final post = _cache.postOf(albumId);
    if (post == null || post.viewers.any((v) => v.id == viewer.id)) return;
    _emit(_cache.copyWith(posts: {
      ..._cache.posts,
      albumId: post.copyWith(viewers: [...post.viewers, viewer]),
    }));
  }

  @override
  void onCommentAdded(int albumId) => _addCommentCount(albumId, 1);

  @override
  void onCommentDeleted(int albumId, {int count = 1}) =>
      _addCommentCount(albumId, -count);

  void _addCommentCount(int albumId, int delta) {
    if (_disposed || _cache.isDeleted(albumId)) return;
    final stat = _cache.stats[albumId];
    if (stat == null) return;

    final count = stat.commentCount + delta;
    _emit(_cache.copyWith(stats: {
      ..._cache.stats,
      albumId: stat.copyWith(commentCount: count < 0 ? 0 : count),
    }));
  }

  @override
  Future<ApiResult<Comment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  }) async =>
      _remoteDataSource
          .createComment(albumId: albumId, request: request)
          .toApiResult();

  @override
  Future<ApiResult<Comment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  }) async =>
      _remoteDataSource
          .updateComment(commentId: commentId, request: request)
          .toApiResult();

  @override
  Future<ApiResult<void>> deleteComment(int commentId) async =>
      _remoteDataSource.deleteComment(commentId).toApiResult();
}
