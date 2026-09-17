part of '../profile_screen.dart';

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      title: Text(
        '프로필 설정',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const WidyuIcon(
          icon: 'ic_24_arrow_left_bold.svg',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
