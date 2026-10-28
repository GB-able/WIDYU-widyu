import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';
import 'package:widyu/feature/album/post/widgets/comment_edit_field.dart';
import 'package:widyu/feature/album/post/widgets/re_comment_card.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final editController = TextEditingController();
  final editFocusNode = FocusNode();

  int? editingId;

  @override
  void initState() {
    super.initState();
    editFocusNode.addListener(cancelEditOnBlur);
  }

  @override
  void dispose() {
    editController.dispose();
    editFocusNode.dispose();
    super.dispose();
  }

  void cancelEditOnBlur() {
    if (editFocusNode.hasFocus || editingId == null) return;
    setState(() {
      editingId = null;
    });
  }

  void startEdit(Comment target) {
    editController.text = target.content;
    setState(() {
      editingId = target.commentId;
    });
  }

  Future<void> submitEdit() async {
    final viewModel = context.read<PostViewModel>();
    final commentId = editingId;
    final content = editController.text.trim();
    if (commentId == null || content.isEmpty) return;

    final success = await viewModel.editComment(commentId, content);
    if (!mounted) return;

    if (!success) {
      showToast('댓글 수정에 실패했습니다.');
      return;
    }

    setState(() {
      editingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingId == widget.comment.commentId;

    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            ProfileWidget(
              profileImage: widget.comment.author.profileImage,
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
                          widget.comment.author.name,
                          style: MyTypo.subTitle1.copyWith(
                            color: MyColor.black,
                          ),
                        ),
                      ),
                      Text(
                        widget.comment.createdAt.timeAgo,
                        style: MyTypo.helper3.copyWith(color: MyColor.grey500),
                      ),
                    ],
                  ),
                  if (isEditing)
                    CommentEditField(
                      controller: editController,
                      focusNode: editFocusNode,
                      hintText: '댓글을 수정해 주세요.',
                      onSubmitted: submitEdit,
                    )
                  else
                    Text(
                      widget.comment.content,
                      style: MyTypo.body2.copyWith(color: MyColor.grey800),
                      overflow: TextOverflow.visible,
                    ),
                  GestureDetector(
                    onTap: () => context
                        .read<PostViewModel>()
                        .startReply(widget.comment.commentId),
                    child: Text(
                      '답글달기',
                      style: MyTypo.helper.copyWith(color: MyColor.grey500),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.comment.canEdit && !isEditing)
              CommentMoreButton(
                commentId: widget.comment.commentId,
                onEdit: () => startEdit(widget.comment),
              ),
          ],
        ),
        if (widget.comment.replies != null &&
            widget.comment.replies!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              spacing: 8,
              children: [
                for (final reply in widget.comment.replies!)
                  ReCommentCard(
                    mode: editingId == reply.commentId
                        ? ReCommentMode.edit
                        : ReCommentMode.normal,
                    reply: reply,
                    controller: editController,
                    focusNode: editFocusNode,
                    onSubmitted: submitEdit,
                    onEdit: () => startEdit(reply),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
