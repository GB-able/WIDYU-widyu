part of '../my_page_screen.dart';

class _SettingMenuView extends StatelessWidget {
  const _SettingMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '설정',
            style: MyTypo.body2.copyWith(color: MyColor.grey500),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _TextMenu(
              title: '알림 설정',
              onClick: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
