import 'dart:io';

import 'package:widyu/core/model/album/album_comment.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

abstract class AlbumRemoteDataSource {
  Future<ApiResponse<FeedDetail>> fetchFeed(int albumId);

  Future<ApiResponse<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  });

  Future<ApiResponse<InfinitePageResult<Media>>> fetchMediaFeed({
    String? cursor,
  });

  Future<ApiResponse<List<int>>> fetchLikedFeeds();

  Future<ApiResponse<List<int>>> fetchUnlockedAlbums();

  Future<ApiResponse<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  });

  Future<ApiResponse<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  });

  Future<ApiResponse<void>> updateFeed({
    required int albumId,
    required String content,
  });

  Future<ApiResponse<void>> deleteFeed(int albumId);

  Future<ApiResponse<AlbumUnlock>> unlockFeed(int albumId);

  Future<ApiResponse<void>> likeFeed(int albumId);

  Future<ApiResponse<void>> unlikeFeed(int albumId);

  Future<ApiResponse<AlbumComment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  });

  Future<ApiResponse<AlbumComment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  });

  Future<ApiResponse<void>> deleteComment(int commentId);
}
