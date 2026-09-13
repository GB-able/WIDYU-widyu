part of '../goal_screen.dart';

class _GoalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _GoalAppBar({required this.fade});

  final ValueListenable<double> fade;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: fade,
      builder: (context, value, child) => AppBar(
        toolbarHeight: 52,
        backgroundColor: Color.lerp(MyColor.orange300, MyColor.grey100, value),
        title: child,
        centerTitle: true,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => {}, // [TODO] 알림 페이지 생성 후 연결
            child: const IconWidget(
              icon: "notification",
              width: 24,
              color: MyColor.grey600,
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
      ),
      child: Text(
        '목표',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
