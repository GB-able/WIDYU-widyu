import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/myPage/user/user.dart';

part 'post_ui_state.freezed.dart';

enum PostStatus { loading, success, error }

@freezed
abstract class PostUiState with _$PostUiState {
  const PostUiState._();

  const factory PostUiState({
    @Default(PostStatus.loading) PostStatus status,
    @Default(false) bool isBusy,
    FeedDetail? feed,
    User? me,
    int? replyParentId,
    int? editingCommentId,
    // 화면을 연 뒤 알림으로 이동할 댓글. 처음 열 때의 댓글은 화면 파라미터로 받는다.
    int? targetCommentId,
    @Default(AlbumCache()) AlbumCache cache,
  }) = _PostUiState;

  bool get isLocked => feed != null && !cache.isUnlocked(feed!.albumId);
}
