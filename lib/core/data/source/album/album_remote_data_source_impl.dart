import 'dart:io';

import 'package:dio/dio.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/utils/extensions/api_response_extension.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/extensions/map_extension.dart';

class AlbumRemoteDataSourceImpl extends AlbumRemoteDataSource {
  final ApiClient _apiClient;

  AlbumRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  static const String _path = '/albums';

  @override
  Future<ApiResponse<FeedDetail>> fetchFeed(int albumId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId',
        method: HttpMethod.get,
      );
      return response.toApiResponse(FeedDetail.fromJson);
    } catch (e) {
      throw Exception("피드 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/feed',
        method: HttpMethod.get,
        query: {'cursor': cursor, 'date': date?.onlyDate}.compact,
      );
      return response.toApiResponse(
        (json) => InfinitePageResult<Feed>.fromJson(
          json,
          (e) => Feed.fromJson(e as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      throw Exception("피드 목록 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<InfinitePageResult<Media>>> fetchMediaFeed({
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/media',
        method: HttpMethod.get,
        query: {'cursor': cursor}.compact,
      );
      return response.toApiResponse(
        (json) => InfinitePageResult<Media>.fromJson(
          json,
          (e) => Media.fromJson(e as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      throw Exception("미디어 목록 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<List<int>>> fetchLikedFeeds() async {
    try {
      final response = await _apiClient.req(
        path: '$_path/liked',
        method: HttpMethod.get,
      );
      return response.toApiResponse<List<int>>(
        (json) => (json['albumIds'] as List<dynamic>? ?? []).cast<int>(),
      );
    } catch (e) {
      throw Exception("좋아요한 피드 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<List<int>>> fetchUnlockedAlbums() async {
    try {
      final response = await _apiClient.req(
        path: '/members/seniors/unlocked-albums',
        method: HttpMethod.get,
      );
      return response.toApiResponse<List<int>>(
        (json) => (json['albumIds'] as List<dynamic>? ?? []).cast<int>(),
      );
    } catch (e) {
      throw Exception("해금한 앨범 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/calendar',
        method: HttpMethod.get,
        query: {'year': year, 'month': month},
      );
      return response.toApiResponsePrimitives<int>();
    } catch (e) {
      throw Exception("앨범 캘린더 조회에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  }) async {
    try {
      final formData = FormData.fromMap({'content': content});
      for (final file in mediaFiles) {
        formData.files.add(MapEntry(
          'mediaFiles',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }
      final response = await _apiClient.req(
        path: '$_path/upload',
        method: HttpMethod.post,
        body: formData,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("피드 업로드에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> updateFeed({
    required int albumId,
    required String content,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId',
        method: HttpMethod.patch,
        body: {'content': content},
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("피드 수정에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> deleteFeed(int albumId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId',
        method: HttpMethod.delete,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("피드 삭제에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<AlbumUnlock>> unlockFeed(int albumId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId/unlock',
        method: HttpMethod.post,
      );
      return response.toApiResponse(AlbumUnlock.fromJson);
    } catch (e) {
      throw Exception("앨범 해금에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> likeFeed(int albumId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId/like',
        method: HttpMethod.post,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("좋아요에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> unlikeFeed(int albumId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId/like',
        method: HttpMethod.delete,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("좋아요 취소에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<Comment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/$albumId/comments',
        method: HttpMethod.post,
        body: request.toJson().compact,
      );
      return response.toApiResponse(Comment.fromJson);
    } catch (e) {
      throw Exception("댓글 작성에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<Comment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  }) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/comments/$commentId',
        method: HttpMethod.put,
        body: request.toJson(),
      );
      return response.toApiResponse(Comment.fromJson);
    } catch (e) {
      throw Exception("댓글 수정에 실패했습니다: $e");
    }
  }

  @override
  Future<ApiResponse<void>> deleteComment(int commentId) async {
    try {
      final response = await _apiClient.req(
        path: '$_path/comments/$commentId',
        method: HttpMethod.delete,
      );
      return response.toApiResponse<void>((json) => {});
    } catch (e) {
      throw Exception("댓글 삭제에 실패했습니다: $e");
    }
  }
}
