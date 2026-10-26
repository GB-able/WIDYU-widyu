import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/post/post_ui_event.dart';
import 'package:widyu/feature/album/post/post_ui_state.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';
import 'package:widyu/feature/album/post/widgets/comment_card.dart';

part 'widgets/comment_text_field.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key, required this.albumId});

  final int albumId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostViewModel(
        id: albumId,
        repository: context.read<AlbumRepository>(),
        myPageRepository: context.read<MyPageRepository>(),
        albumProvider: context.read<AlbumProvider>(),
      )..init(),
      child: Consumer<PostViewModel>(
        builder: (context, viewModel, _) {
          final uiState = viewModel.uiState;
          final feed = uiState.feed;
          final myProfileImage = uiState.me?.profileImage;
          final isLocked = feed != null &&
              context.select((AlbumProvider p) => !p.isUnlocked(feed.albumId));

          return UiEventListener(
            stream: viewModel.uiEvent,
            onEvent: (event) => switch (event) {
              SendCommentFailure() => showToast("댓글 등록에 실패했습니다."),
              SendReplyFailure() => showToast("답글 등록에 실패했습니다."),
            },
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
                        PostStatus.loading => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        PostStatus.error => RetryWidget(
                            message: "피드를 불러오지 못했어요",
                            onRetry: viewModel.retry,
                          ),
                        PostStatus.success when feed == null => RetryWidget(
                            message: "피드를 불러오지 못했어요",
                            onRetry: viewModel.retry,
                          ),
                        PostStatus.success => SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: FeedWidget(
                                    albumId: albumId,
                                    key: ValueKey(albumId),
                                    isDetail: true,
                                    onDeleted: () => context.pop(),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 8,
                                            children: [
                                              Text(
                                                "첫번째 댓글을 달아주세요",
                                                style: MyTypo.title2.copyWith(
                                                  color: MyColor.grey700,
                                                ),
                                              ),
                                              Text(
                                                "가족들의 사랑스러운 순간들을 보고 댓글을 남겨주세요.",
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
                                                  (e) =>
                                                      CommentCard(comment: e),
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
                    if (!isLocked)
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
