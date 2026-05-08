part of '../my_page_screen.dart';

class _ManagementMenuView extends StatelessWidget {
  const _ManagementMenuView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: const BoxDecoration(color: MyColor.white),
      child: Column(
        children: [
          _ManagementMenuContent(
            asset: 'assets/icons/ic_24_phone.svg',
            title: '비상연락처 관리',
            onClick: () => context.push(AppRoute.contact.path),
          ),
          _ManagementMenuContent(
            asset: 'assets/icons/ic_24_house.svg',
            title: '가족 멤버 관리',
            onClick: () => {},
          ),
          _ManagementMenuContent(
            asset: 'assets/icons/ic_24_card.svg',
            title: '멤버십/구독 관리',
            onClick: () => {},
          ),
        ],
      ),
    );
  }
}
