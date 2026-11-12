import 'package:flutter/material.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';
import 'package:widyu/feature/album/post/widgets/comment_edit_field.dart';
import 'package:widyu/feature/album/post/widgets/re_comment_card.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.editingId,
    required this.editController,
    required this.editFocusNode,
    required this.onSubmitEdit,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
  });

  final Comment comment;
  final int? editingId;
  final TextEditingController editController;
  final FocusNode editFocusNode;
  final VoidCallback onSubmitEdit;
  final ValueChanged<int> onReply;
  final ValueChanged<Comment> onEdit;
  final Future<bool> Function(int commentId) onDelete;

  @override
  Widget build(BuildContext context) {
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
                      controller: editController,
                      focusNode: editFocusNode,
                      hintText: '댓글을 수정해 주세요.',
                      onSubmitted: onSubmitEdit,
                    )
                  else
                    Text(
                      comment.content,
                      style: MyTypo.body2.copyWith(color: MyColor.grey800),
                      overflow: TextOverflow.visible,
                    ),
                  GestureDetector(
                    onTap: () => onReply(comment.commentId),
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
                onEdit: () => onEdit(comment),
                onDelete: () => onDelete(comment.commentId),
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
                    controller: editController,
                    focusNode: editFocusNode,
                    onSubmitted: onSubmitEdit,
                    onEdit: () => onEdit(reply),
                    onDelete: () => onDelete(reply.commentId),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
