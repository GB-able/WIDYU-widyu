import 'package:flutter/material.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/profile_widget.dart';
import 'package:widyu/feature/album/_widgets/comment_menu.dart';

enum ReCommentMode { normal, edit }

class ReCommentCard extends StatelessWidget {
  const ReCommentCard({
    super.key,
    required this.mode,
    this.reply,
    this.controller,
    this.onSubmitted,
    this.onEdit,
  });

  final ReCommentMode mode;
  final Comment? reply;
  final TextEditingController? controller;
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
            ),
          ),
          if (comment != null && comment.canEdit)
            GestureDetector(
              onTap: () =>
                  showCommentMenu(context, comment.commentId, onEdit: onEdit),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: IconWidget(icon: 'more', width: 18),
              ),
            ),
        ],
      );
    }
    return Row(
      spacing: 4,
      children: [
        ProfileWidget(profileImage: comment?.author.profileImage, size: 20),
        Expanded(
          child: TextFormField(
            controller: controller,
            autofocus: true,
            style: MyTypo.body2.copyWith(color: MyColor.grey800),
            textInputAction: TextInputAction.done,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onFieldSubmitted: (_) => onSubmitted?.call(),
            decoration: InputDecoration(
              hintText: '답글을 수정해 주세요.',
              hintStyle: MyTypo.body2.copyWith(color: MyColor.grey600),
              contentPadding: EdgeInsets.zero,
              isDense: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
