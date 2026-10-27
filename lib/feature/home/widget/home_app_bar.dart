part of '../home_screen.dart';

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      backgroundColor: MyColor.transparent,
      titleSpacing: 16,
      title: Text(
        '위듀',
        style: MyTypo.kccTitle.copyWith(color: MyColor.black),
      ),
      actions: [
        GestureDetector(
          onTap: () => context.push(AppRoute.notification.path),
          child: const IconWidget(
            icon: 'notification',
            width: 22,
            height: 22,
            color: MyColor.black,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
