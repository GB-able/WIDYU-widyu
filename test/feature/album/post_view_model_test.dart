import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/album/post/post_ui_event.dart';
import 'package:widyu/feature/album/post/post_ui_state.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';

import 'album_fakes.dart';

class _MyPage extends Fake implements MyPageRepository {
  @override
  Future<ApiResult<User>> fetchUser() async =>
      const Success(User(memberId: 1, name: '나', points: 0));
}

const _postId = 1;

void main() {
  late FakeAlbumDataSource dataSource;
  late AlbumRepositoryImpl repository;
  late ProviderContainer container;
  late List<PostUiEvent> events;

  final provider = postViewModelProvider(_postId);

  setUp(() {
    dataSource = FakeAlbumDataSource()..unlocked = okResponse([_postId]);
    repository = fakeAlbumRepository(dataSource);
    container = ProviderContainer.test(
      overrides: [
        albumRepositoryProvider.overrideWithValue(repository),
        myPageRepositoryProvider.overrideWithValue(_MyPage()),
      ],
    );
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  PostViewModel listen() {
    container.listen(provider, (_, __) {});
    final viewModel = container.read(provider.notifier);
    viewModel.uiEvent.listen(events.add);
    return viewModel;
  }

  PostUiState state() => container.read(provider);

  int commentCount() => repository.currentCache.statOf(_postId).commentCount;

  Future<PostViewModel> loaded() async {
    dataSource.detail =
        okResponse(feedDetail(_postId, comments: [comment(10)]));
    final viewModel = listen();
    await pumpEventQueue();
    return viewModel;
  }

  test('게시물을 불러와 댓글을 오래된 순으로 정렬하고 본 사람에 나를 더한다', () async {
    dataSource.detail = okResponse(feedDetail(_postId, comments: [
      comment(11, createdAt: DateTime(2026, 11, 2)),
      comment(10, createdAt: DateTime(2026, 11)),
    ]));
    listen();
    expect(state().status, PostStatus.loading);

    await pumpEventQueue();
    expect(state().status, PostStatus.success);
    expect(state().feed!.comments.map((c) => c.commentId), [10, 11]);
    expect(state().isLocked, isFalse);
    expect(
      repository.currentCache.postOf(_postId)!.viewers,
      [const Member(id: 1, name: '나')],
    );
    expect(events, isEmpty);
  });

  test('잠긴 게시물이면 잠금 해제를 요청한다', () async {
    dataSource
      ..unlocked = okResponse(<int>[])
      ..detail = okResponse(feedDetail(_postId));
    listen();
    await pumpEventQueue();
    expect(state().isLocked, isTrue);
    expect(events.single, isA<FeedLocked>());
  });

  test('삭제된 게시물이면 알린다', () async {
    dataSource.detail = errorResponse('ALBUM_4040');
    listen();
    await pumpEventQueue();
    expect(events.single, isA<FeedDeleted>());
  });

  test('조회 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    await pumpEventQueue();
    expect(dataSource.calls, isEmpty);
  });

  test('조회 중 폐기되면 캐시에 반영하지 않고 이벤트도 보내지 않는다', () async {
    dataSource.detail = okResponse(feedDetail(_postId));
    dataSource.gates['fetchFeed'] = Completer();
    listen();
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['fetchFeed']!.complete();
    await pumpEventQueue();
    expect(repository.currentCache.postOf(_postId), isNull);
    expect(events, isEmpty);
  });

  test('댓글을 등록하면 내 댓글로 붙이고 댓글 수를 늘린다', () async {
    final viewModel = await loaded();
    dataSource.createdComment = okResponse(
      comment(20).copyWith(author: const Member(id: 1, name: '')),
    );

    expect(await viewModel.sendComment('  안녕  '), isTrue);
    final added = state().feed!.comments.last;
    expect(added.commentId, 20);
    expect(added.canEdit, isTrue);
    expect(added.author.name, '나');
    expect(state().isBusy, isFalse);
    expect(commentCount(), 2);
  });

  test('댓글 등록 중 화면이 닫혀도 댓글 수는 반영한다', () async {
    final viewModel = await loaded();
    dataSource
      ..createdComment = okResponse(comment(20))
      ..gates['createComment'] = Completer();
    final sent = viewModel.sendComment('안녕');
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['createComment']!.complete();
    expect(await sent, isTrue);
    expect(commentCount(), 2);
  });

  test('댓글 삭제 중 화면이 닫혀도 답글까지 댓글 수에서 뺀다', () async {
    dataSource.detail = okResponse(feedDetail(_postId, comments: [
      comment(10, replies: [comment(11), comment(12)]),
      comment(13),
    ]));
    final viewModel = listen();
    await pumpEventQueue();
    dataSource.gates['deleteComment'] = Completer();
    final deleted = viewModel.deleteComment(10);
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['deleteComment']!.complete();
    expect(await deleted, isTrue);
    expect(commentCount(), 1);
  });

  test('댓글 수정 중 화면이 닫혀도 예외 없이 끝난다', () async {
    final viewModel = await loaded();
    dataSource
      ..updatedComment = okResponse(comment(10))
      ..gates['updateComment'] = Completer();
    viewModel.startEdit(10);
    final edited = viewModel.submitEdit('수정');
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['updateComment']!.complete();
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    await edited;
  });

  test('댓글 수정에 실패하면 알리고 수정 상태를 유지한다', () async {
    final viewModel = await loaded();
    viewModel.startEdit(10);

    await viewModel.submitEdit('수정');
    await pumpEventQueue();
    expect(events.single, isA<EditCommentFailure>());
    expect(state().editingCommentId, 10);
  });

  test('답글을 등록하면 부모 댓글의 답글 목록에 붙이고 댓글 수를 늘린다', () async {
    final viewModel = await loaded();
    viewModel.startReply(10);
    dataSource.createdComment = okResponse(
      comment(21).copyWith(author: const Member(id: 1, name: '')),
    );

    expect(await viewModel.sendComment('답글'), isTrue);
    final parent = state().feed!.comments.single;
    expect(parent.replies!.map((r) => r.commentId), [21]);
    expect(parent.replies!.single.author.name, '나');
    expect(state().isBusy, isFalse);
    expect(commentCount(), 2);
  });

  test('답글 등록에 실패하면 알린다', () async {
    final viewModel = await loaded();
    viewModel.startReply(10);

    expect(await viewModel.sendComment('답글'), isFalse);
    await pumpEventQueue();
    expect(events.single, isA<SendReplyFailure>());
    expect(state().isBusy, isFalse);
  });
}
