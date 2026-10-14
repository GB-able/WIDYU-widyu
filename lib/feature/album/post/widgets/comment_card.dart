import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';
import 'package:widyu/feature/album/post/post_view_model.dart';
import 'package:widyu/feature/album/post/widgets/re_comment_card.dart';

enum CommentCardMode { normal, writing }

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment, this.myProfileImage});

  final Comment comment;
  final String? myProfileImage;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final replyController = TextEditingController();
  final editController = TextEditingController();

  CommentCardMode mode = CommentCardMode.normal;
  int? editingId;

  @override
  void dispose() {
    replyController.dispose();
    editController.dispose();
    super.dispose();
  }

  void startReply() {
    replyController.clear();
    setState(() {
      editingId = null;
      mode = CommentCardMode.writing;
    });
  }

  void startEdit(Comment target) {
    editController.text = target.content;
    setState(() {
      mode = CommentCardMode.normal;
      editingId = target.commentId;
    });
  }

  Future<void> submitReply() async {
    final viewModel = context.read<PostViewModel>();
    final content = replyController.text.trim();
    if (content.isEmpty) return;

    final success = await viewModel.sendReply(
      widget.comment.commentId,
      content,
    );
    if (!mounted) return;

    if (!success) {
      showToast("답글 등록에 실패했습니다.");
      return;
    }

    replyController.clear();
    setState(() {
      mode = CommentCardMode.normal;
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
      showToast("댓글 수정에 실패했습니다.");
      return;
    }

    setState(() {
      editingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = editingId == widget.comment.commentId;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        ProfileWidget(
          profileImage: widget.comment.author.profileImage,
          size: 32,
        ),
        Expanded(
          child: Column(
            spacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                    TextFormField(
                      controller: editController,
                      autofocus: true,
                      style: MyTypo.body2.copyWith(color: MyColor.grey800),
                      textInputAction: TextInputAction.done,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onFieldSubmitted: (_) => submitEdit(),
                      decoration: InputDecoration(
                        hintText: "댓글을 수정해 주세요.",
                        hintStyle: MyTypo.body2.copyWith(
                          color: MyColor.grey600,
                        ),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    )
                  else
                    Text(
                      widget.comment.content,
                      style: MyTypo.body2.copyWith(color: MyColor.grey800),
                      overflow: TextOverflow.visible,
                    ),
                  GestureDetector(
                    onTap: startReply,
                    child: Text(
                      "답글달기",
                      style: MyTypo.helper.copyWith(color: MyColor.grey500),
                    ),
                  ),
                ],
              ),
              if (widget.comment.replies != null &&
                  widget.comment.replies!.isNotEmpty)
                Column(
                  spacing: 8,
                  children: [
                    for (final reply in widget.comment.replies!)
                      ReCommentCard(
                        parentName: widget.comment.author.name,
                        myProfileImage: widget.myProfileImage,
                        mode: editingId == reply.commentId
                            ? ReCommentMode.edit
                            : ReCommentMode.normal,
                        reply: reply,
                        controller: editController,
                        onSubmitted: submitEdit,
                        onEdit: () => startEdit(reply),
                      ),
                  ],
                ),
              if (mode == CommentCardMode.writing)
                ReCommentCard(
                  parentName: widget.comment.author.name,
                  myProfileImage: widget.myProfileImage,
                  mode: ReCommentMode.add,
                  controller: replyController,
                  onSubmitted: submitReply,
                ),
            ],
          ),
        ),
        if (widget.comment.canEdit && !isEditing)
          GestureDetector(
            onTap: () => showCommentMenu(
              context,
              widget.comment.commentId,
              onEdit: () => startEdit(widget.comment),
            ),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: IconWidget(icon: "more", width: 24),
            ),
          ),
      ],
    );
  }
}
