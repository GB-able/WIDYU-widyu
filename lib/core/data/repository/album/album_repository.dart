import 'dart:io';

import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

abstract class AlbumRepository {
  /// 게시물·좋아요·잠금 해제 캐시. 구독 시 최신 값을 먼저 받는다.
  Stream<AlbumCache> get cache;
  AlbumCache get currentCache;
  bool get isDisposed;

  Future<ApiResult<FeedDetail>> fetchFeed(int albumId);

  Future<ApiResult<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  });

  Future<ApiResult<InfinitePageResult<Media>>> fetchMediaFeed({String? cursor});

  Future<ApiResult<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  });

  /// 조회 결과를 캐시에 반영한다. 오래된 요청을 걸러낸 뒤 호출해야 한다.
  void hydrate(Iterable<FeedBase> feeds);

  Future<void> loadLikedAlbumIds();

  Future<void> ensureUnlockedLoaded();

  Future<void> loadUnlockedAlbumIds();

  Future<void> toggleLike(int albumId);

  Future<bool> unlock(int albumId);

  Future<ApiResult<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  });

  Future<bool> updateFeed({
    required int albumId,
    required String content,
  });

  Future<bool> deleteFeed(int albumId);

  void addViewer(int albumId, Member viewer);

  void onCommentAdded(int albumId);

  void onCommentDeleted(int albumId, {int count = 1});

  Future<ApiResult<Comment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  });

  Future<ApiResult<Comment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  });

  Future<ApiResult<void>> deleteComment(int commentId);

  void dispose();
}
