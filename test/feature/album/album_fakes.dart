import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

// 앨범 ViewModel 테스트는 실제 AlbumRepositoryImpl(캐시)에 서버 응답만 흉내 낸 data source를 붙여 쓴다.

ApiResponse<T> okResponse<T>([T? data]) =>
    ApiResponse(statusCode: 200, code: 'OK', message: '', data: data);

ApiResponse<T> errorResponse<T>([String code = 'ERROR']) =>
    ApiResponse(statusCode: 400, code: code, message: '');

final _createdAt = DateTime(2026, 11, 3);

Feed feed(int albumId) => Feed(
      albumId: albumId,
      authorName: '작성자',
      content: '내용 $albumId',
      mediaUrls: const [],
      thumbnailUrls: const [],
      likeCount: 0,
      commentCount: 0,
      viewers: const [],
      createdAt: _createdAt,
      canEdit: false,
      price: 10,
    );

Media media(int id, {required int postId}) => Media(
      id: id,
      postId: postId,
      type: MediaType.image,
      duration: null,
      thumbnailUrl: null,
      createdAt: '2026-11-03T00:00:00',
      price: 10,
    );

Comment comment(int id, {DateTime? createdAt, List<Comment>? replies}) =>
    Comment(
      commentId: id,
      content: '댓글 $id',
      createdAt: createdAt ?? _createdAt,
      author: const Member(id: 2, name: '가족'),
      replies: replies,
    );

FeedDetail feedDetail(int albumId, {List<Comment> comments = const []}) =>
    FeedDetail(
      albumId: albumId,
      content: '내용 $albumId',
      mediaUrls: const [],
      likeCount: 0,
      commentCount: comments.fold(
        0,
        (count, comment) => count + 1 + (comment.replies?.length ?? 0),
      ),
      price: 10,
      author: const Member(id: 2, name: '가족'),
      comments: comments,
      createdAt: _createdAt,
      canEdit: false,
    );

InfinitePageResult<T> page<T>(List<T> items, {String? next}) =>
    InfinitePageResult(items: items, nextCursor: next, hasNext: next != null);

class FakeAlbumDataSource extends Fake implements AlbumRemoteDataSource {
  final calls = <String>[];

  /// 이름이 같은 요청은 complete될 때까지 응답을 붙잡는다.
  final gates = <String, Completer<void>>{};

  // 응답은 요청 시점의 값을 쓴다.
  ApiResponse<InfinitePageResult<Feed>> feeds = okResponse(page(<Feed>[]));
  ApiResponse<InfinitePageResult<Media>> mediaFeed =
      okResponse(page(<Media>[]));
  ApiResponse<List<int>> calendarDays = okResponse(<int>[]);
  ApiResponse<FeedDetail> detail = errorResponse();
  ApiResponse<List<int>> unlocked = okResponse(<int>[]);
  ApiResponse<Comment> createdComment = errorResponse();
  ApiResponse<Comment> updatedComment = errorResponse();
  ApiResponse<void> deletedComment = okResponse();
  ApiResponse<void> uploaded = okResponse();
  ApiResponse<void> updated = okResponse();

  Future<R> _call<R>(String name, R response) async {
    calls.add(name);
    await gates[name]?.future;
    return response;
  }

  @override
  Future<ApiResponse<InfinitePageResult<Feed>>> fetchFeeds({
    String? cursor,
    DateTime? date,
  }) =>
      _call('fetchFeeds', feeds);

  @override
  Future<ApiResponse<InfinitePageResult<Media>>> fetchMediaFeed({
    String? cursor,
  }) =>
      _call('fetchMediaFeed', mediaFeed);

  @override
  Future<ApiResponse<List<int>>> fetchCalendarDays({
    required int year,
    required int month,
  }) =>
      _call('fetchCalendarDays', calendarDays);

  @override
  Future<ApiResponse<FeedDetail>> fetchFeed(int albumId) =>
      _call('fetchFeed', detail);

  @override
  Future<ApiResponse<List<int>>> fetchUnlockedAlbums() =>
      _call('fetchUnlockedAlbums', unlocked);

  @override
  Future<ApiResponse<void>> deleteFeed(int albumId) =>
      _call('deleteFeed', okResponse<void>());

  @override
  Future<ApiResponse<Comment>> createComment({
    required int albumId,
    required AlbumCommentCreateRequest request,
  }) =>
      _call('createComment', createdComment);

  @override
  Future<ApiResponse<Comment>> updateComment({
    required int commentId,
    required AlbumCommentUpdateRequest request,
  }) =>
      _call('updateComment', updatedComment);

  @override
  Future<ApiResponse<void>> deleteComment(int commentId) =>
      _call('deleteComment', deletedComment);

  @override
  Future<ApiResponse<void>> uploadFeed({
    required List<File> mediaFiles,
    required String content,
  }) =>
      _call('uploadFeed', uploaded);

  @override
  Future<ApiResponse<void>> updateFeed({
    required int albumId,
    required String content,
  }) =>
      _call('updateFeed', updated);
}

class FakePointRepository extends Fake implements PointRepository {
  int refreshCalls = 0;

  @override
  Future<void> refresh() async => refreshCalls++;
}

AlbumRepositoryImpl fakeAlbumRepository(FakeAlbumDataSource dataSource) =>
    AlbumRepositoryImpl(
      remoteDataSource: dataSource,
      pointRepository: FakePointRepository(),
    );
