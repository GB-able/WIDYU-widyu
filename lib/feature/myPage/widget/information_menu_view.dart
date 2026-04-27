part of '../my_page_screen.dart';

class _InformationMenuView extends StatelessWidget {
  const _InformationMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion =
        context.select<MyPageViewModel, String>((vm) => vm.appVersion);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이용정보',
            style: MyTypo.body2.copyWith(color: MyColor.grey500),
          ),
          _TextMenu(
            title: '약관 및 정책',
            onClick: () => {},
          ),
          _TextMenu(
            title: '고객지원',
            onClick: () => {},
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
            child: GestureDetector(
              onTap: () => {},
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  '로그아웃',
                  style: MyTypo.body1.copyWith(color: MyColor.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
            child: Row(
              children: [
                Text(
                  '앱 버전',
                  style: MyTypo.body1.copyWith(color: MyColor.black),
                ),
                const Spacer(),
                Text(
                  appVersion,
                  style: MyTypo.body1.copyWith(color: MyColor.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
