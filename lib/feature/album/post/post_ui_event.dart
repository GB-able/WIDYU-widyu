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
