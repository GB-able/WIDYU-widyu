part of '../my_page_screen.dart';

class _ManagementMenuView extends StatelessWidget {
  const _ManagementMenuView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(color: MyColor.white),
      child: Column(
        children: [
          _TextMenu(
            asset: Assets.icons.ic24Phone,
            title: '비상연락처 관리',
            onClick: () => context.push(AppRoute.contact.path),
          ),
          _TextMenu(
            asset: Assets.icons.ic24House,
            title: '가족 멤버 관리',
            onClick: () => context.push(AppRoute.management.path),
          ),
          // _TextMenu(
          //   asset: Assets.icons.ic24Card,
          //   title: '멤버십/구독 관리',
          //   onClick: () => {},
          // ),
        ],
      ),
    );
  }
}
