import 'dart:io';

import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  final AlbumRemoteDataSource _remoteDataSource;

  AlbumRepositoryImpl({required AlbumRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

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
  Future<ApiResult<List<int>>> fetchLikedFeeds() async =>
      _remoteDataSource.fetchLikedFeeds().toApiResult();

  @override
  Future<ApiResult<List<int>>> fetchUnlockedAlbums() async =>
      _remoteDataSource.fetchUnlockedAlbums().toApiResult();

  @override
  Future<ApiResult<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  }) async =>
      _remoteDataSource
          .fetchCalendarDays(year: year, month: month)
          .toApiResult();

  @override
  Future<ApiResult<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  }) async =>
      _remoteDataSource
          .uploadFeed(mediaFiles: mediaFiles, content: content)
          .toApiResult();

  @override
  Future<ApiResult<void>> updateFeed({
    required int albumId,
    required String content,
  }) async =>
      _remoteDataSource
          .updateFeed(albumId: albumId, content: content)
          .toApiResult();

  @override
  Future<ApiResult<void>> deleteFeed(int albumId) async =>
      _remoteDataSource.deleteFeed(albumId).toApiResult();

  @override
  Future<ApiResult<AlbumUnlock>> unlockFeed(int albumId) async =>
      _remoteDataSource.unlockFeed(albumId).toApiResult();

  @override
  Future<ApiResult<void>> likeFeed(int albumId) async =>
      _remoteDataSource.likeFeed(albumId).toApiResult();

  @override
  Future<ApiResult<void>> unlikeFeed(int albumId) async =>
      _remoteDataSource.unlikeFeed(albumId).toApiResult();

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
