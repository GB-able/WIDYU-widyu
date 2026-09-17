part of '../my_page_screen.dart';

class _MyPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MyPageAppBar();

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.orange400,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
      title: Text(
        "내 정보",
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
    );
  }
}
