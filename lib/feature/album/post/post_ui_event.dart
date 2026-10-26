sealed class PostUiEvent {
  const PostUiEvent();
}

class SendCommentFailure extends PostUiEvent {
  const SendCommentFailure();
}

class SendReplyFailure extends PostUiEvent {
  const SendReplyFailure();
}
