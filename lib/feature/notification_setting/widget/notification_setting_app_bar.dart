part of '../notification_setting_screen.dart';

class _NotificationSettingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _NotificationSettingAppBar();

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      title: Text(
        '알림 설정',
        style: MyTypo.title4.copyWith(color: MyColor.grey800),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: WiduIcon(
          icon: Assets.icons.ic24ArrowLeftBold,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
