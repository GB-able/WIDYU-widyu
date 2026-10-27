import 'dart:io';

import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

abstract class AlbumRepository {
  Future<ApiResult<FeedDetail>> fetchFeed(int albumId);

  Future<ApiResult<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  });

  Future<ApiResult<InfinitePageResult<Media>>> fetchMediaFeed({String? cursor});

  Future<ApiResult<List<int>>> fetchLikedFeeds();

  Future<ApiResult<List<int>>> fetchUnlockedAlbums();

  Future<ApiResult<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  });

  Future<ApiResult<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  });

  Future<ApiResult<void>> updateFeed({
    required int albumId,
    required String content,
  });

  Future<ApiResult<void>> deleteFeed(int albumId);

  Future<ApiResult<AlbumUnlock>> unlockFeed(int albumId);

  Future<ApiResult<void>> likeFeed(int albumId);

  Future<ApiResult<void>> unlikeFeed(int albumId);

  Future<ApiResult<Comment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  });

  Future<ApiResult<Comment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  });

  Future<ApiResult<void>> deleteComment(int commentId);
}
