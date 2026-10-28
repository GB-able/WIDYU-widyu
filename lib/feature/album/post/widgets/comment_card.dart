import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';
import 'package:widyu/feature/album/post/widgets/comment_edit_field.dart';
import 'package:widyu/feature/album/post/widgets/re_comment_card.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.editingId,
  });

  final Comment comment;
  final int? editingId;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PostViewModel>();
    final isEditing = editingId == comment.commentId;

    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            ProfileWidget(
              profileImage: comment.author.profileImage,
              size: 32,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: isEditing ? 4 : 0,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      Flexible(
                        child: Text(
                          comment.author.name,
                          style: MyTypo.subTitle1.copyWith(
                            color: MyColor.black,
                          ),
                        ),
                      ),
                      Text(
                        comment.createdAt.timeAgo,
                        style: MyTypo.helper3.copyWith(color: MyColor.grey500),
                      ),
                    ],
                  ),
                  if (isEditing)
                    CommentEditField(
                      controller: viewModel.editController,
                      focusNode: viewModel.editFocusNode,
                      hintText: '댓글을 수정해 주세요.',
                      onSubmitted: viewModel.submitEdit,
                    )
                  else
                    Text(
                      comment.content,
                      style: MyTypo.body2.copyWith(color: MyColor.grey800),
                      overflow: TextOverflow.visible,
                    ),
                  GestureDetector(
                    onTap: () => viewModel.startReply(comment.commentId),
                    child: Text(
                      '답글달기',
                      style: MyTypo.helper.copyWith(color: MyColor.grey500),
                    ),
                  ),
                ],
              ),
            ),
            if (comment.canEdit && !isEditing)
              CommentMoreButton(
                commentId: comment.commentId,
                onEdit: () => viewModel.startEdit(comment),
              ),
          ],
        ),
        if (comment.replies != null && comment.replies!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              spacing: 8,
              children: [
                for (final reply in comment.replies!)
                  ReCommentCard(
                    mode: editingId == reply.commentId
                        ? ReCommentMode.edit
                        : ReCommentMode.normal,
                    reply: reply,
                    controller: viewModel.editController,
                    focusNode: viewModel.editFocusNode,
                    onSubmitted: viewModel.submitEdit,
                    onEdit: () => viewModel.startEdit(reply),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
