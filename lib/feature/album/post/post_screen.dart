import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/model/album/album_stat.dart';
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

class PostScreen extends StatelessWidget {
  const PostScreen({super.key, required this.postId});

  final int postId;

  // 탭(이벤트) 시점의 캐시와 포인트로 판단한다.
  Future<bool> _requestUnlock(BuildContext context) async {
    final repository = context.read<AlbumRepository>();
    final cache = repository.currentCache;
    final success = await showUnlockDialog(
      context,
      price: cache.postOf(postId)?.price,
      point: context.read<PointRepository>().currentStatus.point,
      isUnlocking: cache.isUnlocking(postId),
      onPurchase: () => repository.unlock(postId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  void _handleEvent(
    BuildContext context,
    PostViewModel viewModel,
    PostUiEvent event,
  ) {
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
        _requestUnlock(context).then((unlocked) {
          if (!context.mounted) return;
          unlocked ? viewModel.retry() : context.pop();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostViewModel(
        id: postId,
        repository: context.read<AlbumRepository>(),
        myPageRepository: context.read<MyPageRepository>(),
      )..init(),
      // 화면은 uiState와 잠금 여부만 구독하고, 피드는 아래 Selector로 따로 구독한다.
      child: Selector<PostViewModel, (PostUiState, bool)>(
        selector: (_, vm) {
          final feed = vm.uiState.feed;
          return (
            vm.uiState,
            feed != null && !vm.cache.isUnlocked(feed.albumId),
          );
        },
        builder: (context, state, _) {
          final viewModel = context.read<PostViewModel>();
          final (uiState, isLocked) = state;
          final feed = uiState.feed;
          final myProfileImage = uiState.me?.profileImage;

          return UiEventListener(
            stream: viewModel.uiEvent,
            onEvent: (event) => _handleEvent(context, viewModel, event),
            child: PopScope(
              canPop: uiState.replyParentId == null,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) viewModel.cancelReply();
              },
              child: Scaffold(
                appBar: const CustomAppBar(),
                body: Column(
                  children: [
                    Expanded(
                      child: switch (uiState.status) {
                        PostStatus.loading => const CustomLoadingWidget(),
                        PostStatus.error => CustomErrorWidget(
                            errorMsg: '피드를 불러오지 못했어요',
                            onRetry: viewModel.retry,
                          ),
                        PostStatus.success => SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Selector<PostViewModel,
                                      (AlbumPost?, AlbumStat, bool)>(
                                    selector: (_, vm) => (
                                      vm.cache.postOf(postId),
                                      vm.cache.statOf(postId),
                                      vm.cache.isUnlocked(postId),
                                    ),
                                    builder: (context, row, _) {
                                      final (post, stat, isUnlocked) = row;
                                      if (post == null) {
                                        return const SizedBox.shrink();
                                      }
                                      return FeedWidget(
                                        feed: post,
                                        stat: stat,
                                        isLocked: !isUnlocked,
                                        onToggleLike: viewModel.toggleLike,
                                        onDelete: viewModel.deleteFeed,
                                        onRequestUnlock: () =>
                                            _requestUnlock(context),
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
                                    child: feed!.comments.isEmpty
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
                                            children: viewModel.visibleComments
                                                .map(
                                                  (e) => CommentCard(
                                                    comment: e,
                                                    editingId: uiState
                                                        .editingCommentId,
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
                        controller: viewModel.commentController,
                        focusNode: viewModel.commentFocusNode,
                        isReply: uiState.replyParentId != null,
                        onSend: viewModel.sendComment,
                        onCancelReply: viewModel.cancelReply,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
