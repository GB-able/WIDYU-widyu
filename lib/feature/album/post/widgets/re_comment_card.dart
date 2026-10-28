import 'package:flutter/material.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';
import 'package:widyu/feature/album/post/widgets/comment_edit_field.dart';

enum ReCommentMode { normal, edit }

class ReCommentCard extends StatelessWidget {
  const ReCommentCard({
    super.key,
    required this.mode,
    this.reply,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onEdit,
  });

  final ReCommentMode mode;
  final Comment? reply;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final comment = reply;

    if (mode == ReCommentMode.normal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          ProfileWidget(profileImage: comment?.author.profileImage, size: 20),
          Expanded(
            child: Text(
              comment == null ? '오류가 발생했습니다.' : comment.content,
              style: MyTypo.body2.copyWith(color: MyColor.grey800),
              overflow: TextOverflow.visible,
            ),
          ),
          if (comment != null && comment.canEdit)
            CommentMoreButton(
              commentId: comment.commentId,
              onEdit: onEdit ?? () {},
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            ),
        ],
      );
    }
    return Row(
      spacing: 4,
      children: [
        ProfileWidget(profileImage: comment?.author.profileImage, size: 20),
        Expanded(
          child: CommentEditField(
            controller: controller!,
            focusNode: focusNode,
            hintText: '답글을 수정해 주세요.',
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}
