part of '../goal_screen.dart';

class _GoalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GoalAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      backgroundColor: MyColor.white,
      surfaceTintColor: MyColor.white,
      title: Text(
        '목표',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => context.push(AppRoute.notification.path),
          child: WiduIcon(
            icon: Assets.icons.ic22Notification,
            width: 22,
            color: MyColor.grey600,
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
