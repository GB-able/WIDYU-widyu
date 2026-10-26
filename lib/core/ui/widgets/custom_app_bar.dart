import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.canBack = true,
    this.onBack,
    this.actions,
  });

  final String title;
  final bool canBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      backgroundColor: MyColor.white,
      automaticallyImplyLeading: false,
      leadingWidth: 38,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: canBack
            ? GestureDetector(
                onTap: () {
                  onBack?.call();
                  context.pop();
                },
                child: const IconWidget(
                  icon: 'back',
                  width: 24,
                  color: MyColor.grey600,
                ),
              )
            : const SizedBox.shrink(),
      ),
      actions: actions,
      actionsPadding: const EdgeInsets.only(right: 16),
      title: title.isNotEmpty
          ? Text(title, style: MyTypo.title3.copyWith(color: MyColor.grey800))
          : null,
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
