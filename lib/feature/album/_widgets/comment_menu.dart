import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/effects.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/gen/assets.gen.dart';

class CommentMoreButton extends StatefulWidget {
  const CommentMoreButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
  });

  final VoidCallback onEdit;
  final Future<bool> Function() onDelete;
  final EdgeInsets padding;

  @override
  State<CommentMoreButton> createState() => _CommentMoreButtonState();
}

class _CommentMoreButtonState extends State<CommentMoreButton> {
  final link = LayerLink();

  void showMenu() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, __) => Stack(
        children: [
          CompositedTransformFollower(
            link: link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: Offset(-widget.padding.right, 4),
            child: Material(
              type: MaterialType.transparency,
              child: _CommentMenu(
                onEdit: () {
                  Navigator.pop(dialogContext);
                  widget.onEdit();
                },
                onDelete: () {
                  Navigator.pop(dialogContext);
                  _confirmDelete(context, widget.onDelete);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: GestureDetector(
        onTap: showMenu,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: widget.padding,
          child: WiduIcon(icon: Assets.icons.ic18More, width: 18),
        ),
      ),
    );
  }
}

class _CommentMenu extends StatelessWidget {
  const _CommentMenu({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [MyEffects.shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CommentMenuItem(
            icon: Assets.icons.ic16Edit,
            label: '편집하기',
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
            onTap: onEdit,
          ),
          const Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 7,
            endIndent: 7,
            color: MyColor.grey300,
          ),
          _CommentMenuItem(
            icon: Assets.icons.ic16Delete,
            label: '삭제하기',
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _CommentMenuItem extends StatelessWidget {
  const _CommentMenuItem({
    required this.icon,
    required this.label,
    required this.padding,
    required this.onTap,
  });

  final SvgGenImage icon;
  final String label;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding,
        child: Row(
          spacing: 12,
          children: [
            WiduIcon(icon: icon, width: 16),
            Text(
              label,
              style: MyTypo.helper2.copyWith(color: MyColor.grey600),
            ),
          ],
        ),
      ),
    );
  }
}

void _confirmDelete(BuildContext context, Future<bool> Function() onDelete) {
  showDialog<void>(
    context: context,
    builder: (_) => CustomDialog(
      type: CustomDialogType.two,
      title: '댓글을 삭제하시겠어요?',
      description: '삭제한 댓글은 다시 볼 수 없어요.',
      posText: '삭제',
      onPosTap: () async {
        final success = await onDelete();
        if (!success) showToast('댓글 삭제에 실패했습니다.');
      },
    ),
  );
}
