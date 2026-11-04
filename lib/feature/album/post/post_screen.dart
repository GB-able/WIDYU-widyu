import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';
import 'package:widyu/feature/album/post/post_ui_event.dart';
import 'package:widyu/feature/album/post/post_ui_state.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';
import 'package:widyu/feature/album/post/widgets/comment_card.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/comment_text_field.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key, required this.postId});

  final int postId;

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  late final _provider = postViewModelProvider(widget.postId);
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final _editController = TextEditingController();
  final _editFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _editFocusNode.addListener(_cancelEditOnBlur);
  }

  @override
  void dispose() {
    _editFocusNode.removeListener(_cancelEditOnBlur);
    _commentController.dispose();
    _commentFocusNode.dispose();
    _editController.dispose();
    _editFocusNode.dispose();
    super.dispose();
  }

  PostViewModel get _viewModel => ref.read(_provider.notifier);

  void _cancelEditOnBlur() {
    if (!_editFocusNode.hasFocus) _viewModel.cancelEdit();
  }

  void _startReply(int parentCommentId) {
    _commentController.clear();
    _commentFocusNode.requestFocus();
    _viewModel.startReply(parentCommentId);
  }

  void _cancelReply() {
    _commentController.clear();
    _commentFocusNode.unfocus();
    _viewModel.cancelReply();
  }

  void _startEdit(Comment target) {
    _editController.text = target.content;
    _viewModel.startEdit(target.commentId);
  }

  void _submitEdit() => _viewModel.submitEdit(_editController.text);

  Future<void> _sendComment() async {
    final sent = await _viewModel.sendComment(_commentController.text);
    if (sent && mounted) _commentController.clear();
  }

  // 탭(이벤트) 시점의 캐시와 포인트로 판단한다.
  Future<bool> _requestUnlock() async {
    final postId = widget.postId;
    final repository = ref.read(albumRepositoryProvider);
    final cache = repository.currentCache;
    final success = await showUnlockDialog(
      context,
      price: cache.postOf(postId)?.price,
      pointRepository: ref.read(pointRepositoryProvider),
      isUnlocking: cache.isUnlocking(postId),
      onPurchase: () => repository.unlock(postId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  void _handleEvent(PostViewModel viewModel, PostUiEvent event) {
    switch (event) {
      case SendCommentFailure():
        showToast('댓글 등록에 실패했습니다.');
      case SendReplyFailure():
        showToast('답글 등록에 실패했습니다.');
      case EditCommentFailure():
        showToast('댓글 수정에 실패했습니다.');
      case FeedDeleted():
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomDialog(
            title: '삭제된 게시물이에요',
            onPosTap: () => context.pop(),
          ),
        );
      case FeedLocked():
        _requestUnlock().then((unlocked) {
          if (unlocked) viewModel.retry();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.postId;
    final viewModel = ref.watch(_provider.notifier);
    // 화면은 캐시를 뺀 상태와 잠금 여부만 구독하고, 피드는 아래 Consumer로 따로 구독한다.
    final (status, feed, me, replyParentId, editingCommentId, isLocked) =
        ref.watch(
      _provider.select(
        (s) => (
          s.status,
          s.feed,
          s.me,
          s.replyParentId,
          s.editingCommentId,
          s.isLocked,
        ),
      ),
    );
    final myProfileImage = me?.profileImage;
    final comments = feed?.comments ?? const <Comment>[];
    final visibleComments = replyParentId == null
        ? comments
        : comments.where((e) => e.commentId == replyParentId).toList();

    return UiEventListener(
      stream: viewModel.uiEvent,
      onEvent: (event) => _handleEvent(viewModel, event),
      child: PopScope(
        canPop: replyParentId == null,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _cancelReply();
        },
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: Column(
            children: [
              Expanded(
                child: switch (status) {
                  PostStatus.loading => const CustomLoadingWidget(),
                  PostStatus.error => CustomErrorWidget(
                      errorMsg: '피드를 불러오지 못했어요',
                      onRetry: viewModel.retry,
                    ),
                  PostStatus.success => SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Consumer(
                              builder: (context, ref, _) {
                                final (post, stat, isUnlocked) = ref.watch(
                                  _provider.select(
                                    (s) => (
                                      s.cache.postOf(postId),
                                      s.cache.statOf(postId),
                                      s.cache.isUnlocked(postId),
                                    ),
                                  ),
                                );
                                if (post == null) {
                                  return const SizedBox.shrink();
                                }
                                return FeedWidget(
                                  feed: post,
                                  stat: stat,
                                  isLocked: !isUnlocked,
                                  onToggleLike: viewModel.toggleLike,
                                  onDelete: viewModel.deleteFeed,
                                  onRequestUnlock: _requestUnlock,
                                  key: ValueKey(postId),
                                  isDetail: true,
                                  onDeleted: () => context.pop(),
                                );
                              },
                            ),
                          ),
                          if (!isLocked) ...[
                            const Divider(
                              color: MyColor.grey100,
                              thickness: 1,
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              child: comments.isEmpty
                                  ? Column(
                                      spacing: 8,
                                      children: [
                                        Text(
                                          '첫번째 댓글을 달아주세요',
                                          style: MyTypo.title2.copyWith(
                                            color: MyColor.grey700,
                                          ),
                                        ),
                                        Text(
                                          '가족들의 사랑스러운 순간들을 보고 댓글을 남겨주세요.',
                                          style: MyTypo.body2.copyWith(
                                            color: MyColor.grey500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      spacing: 20,
                                      children: visibleComments
                                          .map(
                                            (e) => CommentCard(
                                              comment: e,
                                              editingId: editingCommentId,
                                              editController: _editController,
                                              editFocusNode: _editFocusNode,
                                              onSubmitEdit: _submitEdit,
                                              onReply: _startReply,
                                              onEdit: _startEdit,
                                              onDelete: viewModel.deleteComment,
                                            ),
                                          )
                                          .toList(),
                                    ),
                            ),
                          ],
                        ],
                      ),
                    ),
                },
              ),
              if (feed != null && !isLocked)
                _CommentTextField(
                  profileImage: myProfileImage,
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  isReply: replyParentId != null,
                  onSend: _sendComment,
                  onCancelReply: _cancelReply,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
