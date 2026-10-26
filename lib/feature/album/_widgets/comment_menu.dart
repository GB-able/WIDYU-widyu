import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/feed_menu_sheet.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';

void showCommentMenu(
  BuildContext context,
  int commentId, {
  VoidCallback? onEdit,
}) {
  final viewModel = context.read<PostViewModel>();

  showModalBottomSheet(
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (_) => FeedMenuSheet(
      onEdit: onEdit,
      onDelete: () => _confirmDelete(context, viewModel, commentId),
    ),
  );
}

void _confirmDelete(
  BuildContext context,
  PostViewModel viewModel,
  int commentId,
) {
  showDialog(
    context: context,
    builder: (_) => CustomDialog(
      type: CustomDialogType.two,
      title: '댓글을 삭제하시겠어요?',
      description: '삭제한 댓글은 다시 볼 수 없어요.',
      posText: '삭제',
      onPosTap: () async {
        final success = await viewModel.deleteComment(commentId);
        if (!success) showToast('댓글 삭제에 실패했습니다.');
      },
    ),
  );
}
