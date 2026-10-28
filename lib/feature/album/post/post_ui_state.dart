import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/feed_detail.dart';
import 'package:widyu/core/model/myPage/user/user.dart';

part 'post_ui_state.freezed.dart';

enum PostStatus { loading, success, error }

@freezed
abstract class PostUiState with _$PostUiState {
  const factory PostUiState({
    @Default(PostStatus.loading) PostStatus status,
    @Default(false) bool isBusy,
    FeedDetail? feed,
    User? me,
    int? replyParentId,
    int? editingCommentId,
  }) = _PostUiState;
}
