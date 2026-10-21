part of '../my_page_screen.dart';

class _SettingMenuView extends StatelessWidget {
  const _SettingMenuView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '설정',
              style: MyTypo.body2.copyWith(color: MyColor.grey500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _TextMenu(
              title: '알림 설정',
              onClick: () => context.push(AppRoute.notificationSetting.path),
            ),
          ),
        ],
      ),
    );
  }
}
