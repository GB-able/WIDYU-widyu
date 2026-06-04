part of '../management_screen.dart';

class _ManagementAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ManagementAppBar();

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      title: Text(
        '가족 멤버 관리',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const WidyuIcon(
          icon: 'ic_22_arrow_left_bold.svg',
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}
