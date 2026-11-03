import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/album/post/post_ui_event.dart';
import 'package:widyu/feature/album/post/post_ui_state.dart';

part 'post_view_model.g.dart';

@riverpod
class PostViewModel extends _$PostViewModel {
  final _uiEvent = StreamController<PostUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<PostUiEvent> get uiEvent => _uiEvent.stream;

  AlbumRepository get _repository => ref.read(albumRepositoryProvider);
  MyPageRepository get _myPageRepository => ref.read(myPageRepositoryProvider);

  @override
  PostUiState build(int id) {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_start));
    return PostUiState(cache: _repository.currentCache);
  }

  Future<void> _start() async {
    if (!ref.mounted) return;
    final cacheChanges = _repository.cache.listen(_onCache);
    ref.onDispose(cacheChanges.cancel);
    await init();
  }

  void _onCache(AlbumCache cache) {
    state = state.copyWith(cache: cache);
  }

  void _emit(PostUiEvent event) {
    if (ref.mounted) _uiEvent.add(event);
  }

  // 입력창 비우기·포커스는 화면이 먼저 처리한다.
  void startReply(int parentCommentId) {
    state = state.copyWith(replyParentId: parentCommentId);
  }

  void cancelReply() {
    state = state.copyWith(replyParentId: null);
  }

  void startEdit(int commentId) {
    state = state.copyWith(editingCommentId: commentId);
  }

  void cancelEdit() {
    state = state.copyWith(editingCommentId: null);
  }

  Future<void> submitEdit(String content) async {
    final commentId = state.editingCommentId;
    final trimmed = content.trim();
    if (commentId == null || trimmed.isEmpty) return;

    if (!await editComment(commentId, trimmed)) {
      _emit(const EditCommentFailure());
      return;
    }
    if (!ref.mounted) return;
    state = state.copyWith(editingCommentId: null);
  }

  Comment _mine(Comment data) => data.copyWith(
        canEdit: true,
        author: data.author.copyWith(
          name: data.author.name.isEmpty
              ? (state.me?.name ?? '')
              : data.author.name,
          profileImage: data.author.profileImage ?? state.me?.profileImage,
        ),
      );

  List<Comment> _sortedByOldest(List<Comment> comments) =>
      [...comments]..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  FeedDetail _normalize(FeedDetail feed) => feed.copyWith(
        comments: [
          for (final comment in _sortedByOldest(feed.comments))
            comment.replies == null
                ? comment
                : comment.copyWith(replies: _sortedByOldest(comment.replies!)),
        ],
      );

  Future<void> init() async {
    if (!ref.mounted) return;
    final repository = _repository;
    final albumId = id;
    state = state.copyWith(status: PostStatus.loading);

    unawaited(_fetchMe());
    final unlockedLoaded = repository.ensureUnlockedLoaded();

    final result = await repository.fetchFeed(albumId);
    await unlockedLoaded;
    if (!ref.mounted || repository.isDisposed) {
      return;
    }
    switch (result) {
      case Success<FeedDetail>(:final data):
        repository.hydrate([data]);
        _onCache(repository.currentCache);
        state = state.copyWith(
          status: PostStatus.success,
          feed: _normalize(data),
        );
        _markViewed();
        if (!repository.currentCache.isUnlocked(albumId)) {
          _emit(const FeedLocked());
        }
      case Failure(:final code):
        if (code == 'ALBUM_4040') {
          _emit(const FeedDeleted());
        } else {
          state = state.copyWith(status: PostStatus.error);
        }
    }
  }

  Future<void> _fetchMe() async {
    final repository = _repository;
    final result = await _myPageRepository.fetchUser();
    if (!ref.mounted || repository.isDisposed || result is! Success<User>) {
      return;
    }

    state = state.copyWith(me: result.data);
    _markViewed();
  }

  void _markViewed() {
    final feed = state.feed;
    final me = state.me;
    if (feed == null ||
        me == null ||
        feed.author.id == me.memberId ||
        !_repository.currentCache.isUnlocked(id)) {
      return;
    }
    _repository.addViewer(
      id,
      Member(id: me.memberId, name: me.name, profileImage: me.profileImage),
    );
  }

  Future<void> retry() => init();

  Future<void> toggleLike() => _repository.toggleLike(id);

  Future<bool> deleteFeed() => _repository.deleteFeed(id);

  /// 등록에 성공하면 true를 돌려준다. 화면은 이때 입력창을 비운다.
  Future<bool> sendComment(String text) async {
    if (!ref.mounted) return false;
    final content = text.trim();
    final feed = state.feed;
    if (content.isEmpty || state.isBusy || feed == null) return false;

    final parentId = state.replyParentId;
    if (parentId != null) {
      final sent = await sendReply(parentId, content);
      if (!sent) _emit(const SendReplyFailure());
      return sent;
    }

    final repository = _repository;
    final albumId = id;
    state = state.copyWith(isBusy: true);

    final result = await repository.createComment(
      albumId: albumId,
      request: AlbumCommentCreateRequest(content: content),
    );
    if (repository.isDisposed) return false;
    if (result case Success<Comment>(:final data)) {
      WiduLog.ui.i('댓글 작성 성공 albumId=$albumId commentId=${data.commentId}');
      // 댓글 수는 공유 캐시라 화면이 닫혀도 반영한다.
      repository.onCommentAdded(albumId);
      if (!ref.mounted) return true;
      state = state.copyWith(
        feed: feed.copyWith(comments: [...feed.comments, _mine(data)]),
        isBusy: false,
      );
      return true;
    }

    _emit(const SendCommentFailure());
    if (ref.mounted) state = state.copyWith(isBusy: false);
    return false;
  }

  Future<bool> deleteComment(int commentId) async {
    if (!ref.mounted) return false;
    final feed = state.feed;
    if (feed == null || state.isBusy) return false;

    final repository = _repository;
    final albumId = id;
    state = state.copyWith(isBusy: true);

    try {
      final result = await repository.deleteComment(commentId);
      if (repository.isDisposed) return false;
      if (result is Failure) {
        return false;
      }

      var removed = 0;
      final comments = <Comment>[];

      for (final comment in feed.comments) {
        if (comment.commentId == commentId) {
          removed += 1 + (comment.replies?.length ?? 0);
          continue;
        }

        final replies = comment.replies;
        if (replies != null && replies.any((e) => e.commentId == commentId)) {
          removed += 1;
          comments.add(
            comment.copyWith(
              replies: replies.where((e) => e.commentId != commentId).toList(),
            ),
          );
          continue;
        }

        comments.add(comment);
      }

      if (removed == 0) return false;
      WiduLog.ui
          .i('댓글 삭제 성공 albumId=$albumId commentId=$commentId removed=$removed');

      // 댓글 수는 공유 캐시라 화면이 닫혀도 반영한다.
      repository.onCommentDeleted(albumId, count: removed);
      if (ref.mounted) {
        state = state.copyWith(
          feed: feed.copyWith(comments: comments),
          replyParentId: comments.any((e) => e.commentId == state.replyParentId)
              ? state.replyParentId
              : null,
        );
      }
      return true;
    } finally {
      if (ref.mounted && !repository.isDisposed) {
        state = state.copyWith(isBusy: false);
      }
    }
  }

  Future<bool> sendReply(int parentCommentId, String content) async {
    if (!ref.mounted) return false;
    final trimmed = content.trim();
    final feed = state.feed;
    if (trimmed.isEmpty || state.isBusy || feed == null) return false;

    final repository = _repository;
    final albumId = id;
    state = state.copyWith(isBusy: true);

    try {
      final result = await repository.createComment(
        albumId: albumId,
        request: AlbumCommentCreateRequest(
          content: trimmed,
          parentCommentId: parentCommentId,
        ),
      );
      if (repository.isDisposed || result is! Success<Comment>) {
        return false;
      }

      WiduLog.ui.i('답글 작성 성공 albumId=$albumId '
          'parentCommentId=$parentCommentId commentId=${result.data.commentId}');
      // 댓글 수는 공유 캐시라 화면이 닫혀도 반영한다.
      repository.onCommentAdded(albumId);
      if (ref.mounted) {
        final newReply = _mine(result.data);
        state = state.copyWith(
          feed: feed.copyWith(
            comments: [
              for (final comment in feed.comments)
                if (comment.commentId == parentCommentId)
                  comment.copyWith(replies: [...?comment.replies, newReply])
                else
                  comment,
            ],
          ),
        );
      }
      return true;
    } finally {
      if (ref.mounted && !repository.isDisposed) {
        state = state.copyWith(isBusy: false);
      }
    }
  }

  Future<bool> editComment(int commentId, String content) async {
    if (!ref.mounted) return false;
    final trimmed = content.trim();
    final feed = state.feed;
    if (trimmed.isEmpty || state.isBusy || feed == null) return false;

    final repository = _repository;
    final albumId = id;
    state = state.copyWith(isBusy: true);

    try {
      final result = await repository.updateComment(
        commentId: commentId,
        request: AlbumCommentUpdateRequest(content: trimmed),
      );
      if (repository.isDisposed || result is! Success<Comment>) {
        return false;
      }

      WiduLog.ui.i('댓글 수정 성공 albumId=$albumId commentId=$commentId');
      if (!ref.mounted) return true;
      final updated = result.data.content;
      state = state.copyWith(
        feed: feed.copyWith(
          comments: [
            for (final comment in feed.comments)
              if (comment.commentId == commentId)
                comment.copyWith(content: updated)
              else
                comment.copyWith(
                  replies: comment.replies == null
                      ? null
                      : [
                          for (final reply in comment.replies!)
                            if (reply.commentId == commentId)
                              reply.copyWith(content: updated)
                            else
                              reply,
                        ],
                ),
          ],
        ),
      );
      return true;
    } finally {
      if (ref.mounted && !repository.isDisposed) {
        state = state.copyWith(isBusy: false);
      }
    }
  }
}
