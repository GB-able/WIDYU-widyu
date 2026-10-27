import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/album/album_comment_create_request.dart';
import 'package:widyu/core/model/album/album_comment_update_request.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/album/post/post_ui_state.dart';

class PostViewModel extends ChangeNotifier {
  PostViewModel({
    required this.id,
    required AlbumRepository repository,
    required MyPageRepository myPageRepository,
    required AlbumProvider albumProvider,
  })  : _repository = repository,
        _myPageRepository = myPageRepository,
        _albumProvider = albumProvider;

  bool _disposed = false;
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  final AlbumRepository _repository;
  final MyPageRepository _myPageRepository;
  final AlbumProvider _albumProvider;
  final int id;

  final commentController = TextEditingController();

  PostUiState _uiState = const PostUiState();
  PostUiState get uiState => _uiState;

  void _update(PostUiState Function(PostUiState) change) {
    _uiState = change(_uiState);
    notifyListeners();
  }

  Comment _mine(Comment data) => data.copyWith(
        canEdit: true,
        author: data.author.copyWith(
          name: data.author.name.isEmpty
              ? (_uiState.me?.name ?? '')
              : data.author.name,
          profileImage: data.author.profileImage ?? _uiState.me?.profileImage,
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
    if (_disposed) return;
    _update((s) => s.copyWith(status: PostStatus.loading));

    unawaited(_fetchMe());
    final unlockedLoaded = _albumProvider.ensureUnlockedLoaded();

    final result = await _repository.fetchFeed(id);
    await unlockedLoaded;
    if (_disposed || _albumProvider.isDisposed) {
      return;
    }
    switch (result) {
      case Success<FeedDetail>(:final data):
        _albumProvider.hydrate([data]);
        _update(
          (s) => s.copyWith(status: PostStatus.success, feed: _normalize(data)),
        );
      case Failure():
        _update((s) => s.copyWith(status: PostStatus.error));
    }
  }

  Future<void> _fetchMe() async {
    final result = await _myPageRepository.fetchUser();
    if (_disposed || _albumProvider.isDisposed || result is! Success<User>) {
      return;
    }

    _update((s) => s.copyWith(me: result.data));
  }

  Future<void> retry() => init();

  Future<void> sendComment() async {
    if (_disposed) return;
    final content = commentController.text.trim();
    final feed = _uiState.feed;
    if (content.isEmpty || _uiState.isBusy || feed == null) return;

    _update((s) => s.copyWith(isBusy: true));

    final result = await _repository.createComment(
      albumId: id,
      request: AlbumCommentCreateRequest(content: content),
    );
    if (_albumProvider.isDisposed) return;
    if (result case Success<Comment>(:final data)) {
      final newComment = _mine(data);
      _uiState = _uiState.copyWith(
          feed: feed.copyWith(comments: [...feed.comments, newComment]));
      _albumProvider.onCommentAdded(id);
      if (!_disposed) commentController.clear();
    }

    _update((s) => s.copyWith(isBusy: false));
  }

  Future<bool> deleteComment(int commentId) async {
    if (_disposed) return false;
    final feed = _uiState.feed;
    if (feed == null || _uiState.isBusy) return false;

    _update((s) => s.copyWith(isBusy: true));

    try {
      final result = await _repository.deleteComment(commentId);
      if (_albumProvider.isDisposed) return false;
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

      _uiState = _uiState.copyWith(feed: feed.copyWith(comments: comments));
      _albumProvider.onCommentDeleted(id, count: removed);
      return true;
    } finally {
      if (!_albumProvider.isDisposed) {
        _update((s) => s.copyWith(isBusy: false));
      }
    }
  }

  Future<bool> sendReply(int parentCommentId, String content) async {
    if (_disposed) return false;
    final trimmed = content.trim();
    final feed = _uiState.feed;
    if (trimmed.isEmpty || _uiState.isBusy || feed == null) return false;

    _update((s) => s.copyWith(isBusy: true));

    try {
      final result = await _repository.createComment(
        albumId: id,
        request: AlbumCommentCreateRequest(
          content: trimmed,
          parentCommentId: parentCommentId,
        ),
      );
      if (_albumProvider.isDisposed || result is! Success<Comment>) {
        return false;
      }

      final newReply = _mine(result.data);
      _uiState = _uiState.copyWith(
          feed: feed.copyWith(
        comments: [
          for (final comment in feed.comments)
            if (comment.commentId == parentCommentId)
              comment.copyWith(replies: [...?comment.replies, newReply])
            else
              comment,
        ],
      ));
      _albumProvider.onCommentAdded(id);
      return true;
    } finally {
      if (!_albumProvider.isDisposed) {
        _update((s) => s.copyWith(isBusy: false));
      }
    }
  }

  Future<bool> editComment(int commentId, String content) async {
    if (_disposed) return false;
    final trimmed = content.trim();
    final feed = _uiState.feed;
    if (trimmed.isEmpty || _uiState.isBusy || feed == null) return false;

    _update((s) => s.copyWith(isBusy: true));

    try {
      final result = await _repository.updateComment(
        commentId: commentId,
        request: AlbumCommentUpdateRequest(content: trimmed),
      );
      if (_albumProvider.isDisposed || result is! Success<Comment>) {
        return false;
      }

      final updated = result.data.content;
      _uiState = _uiState.copyWith(
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
      ));
      return true;
    } finally {
      if (!_albumProvider.isDisposed) {
        _update((s) => s.copyWith(isBusy: false));
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    commentController.dispose();
    super.dispose();
  }
}
