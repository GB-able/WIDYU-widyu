part of '../contact_screen.dart';

class _ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ContactAppBar();

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      title: Text(
        '비상연락처 관리',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: SvgPicture.asset(
          'assets/icons/ic_22_arrow_left_bold.svg',
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}
