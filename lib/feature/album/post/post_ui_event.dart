sealed class PostUiEvent {
  const PostUiEvent();
}

class SendCommentFailure extends PostUiEvent {
  const SendCommentFailure();
}

class SendReplyFailure extends PostUiEvent {
  const SendReplyFailure();
}

class EditCommentFailure extends PostUiEvent {
  const EditCommentFailure();
}

class FeedDeleted extends PostUiEvent {
  const FeedDeleted();
}

class FeedLocked extends PostUiEvent {
  const FeedLocked();
}

/// 알림으로 보고 있는 게시물의 댓글을 가리켰을 때, 다시 조회가 끝나면 그 댓글로 이동한다.
class ScrollToComment extends PostUiEvent {
  const ScrollToComment(this.commentId);

  final int commentId;
}
