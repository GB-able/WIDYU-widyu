sealed class PostUiEvent {
  const PostUiEvent();
}

class SendCommentFailure extends PostUiEvent {
  const SendCommentFailure();
}

class SendReplyFailure extends PostUiEvent {
  const SendReplyFailure();
}

class FeedDeleted extends PostUiEvent {
  const FeedDeleted();
}

class FeedLocked extends PostUiEvent {
  const FeedLocked();
}
