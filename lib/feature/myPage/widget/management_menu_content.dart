part of '../my_page_screen.dart';

class _ManagementMenuContent extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onClick;

  const _ManagementMenuContent({
    super.key,
    required this.asset,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(asset, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(title, style: MyTypo.body1.copyWith(color: MyColor.black)),
          const Spacer(),
          IconButton(
            onPressed: onClick,
            icon: SvgPicture.asset(
              'assets/icons/ic_20_chevron_right.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                MyColor.grey400,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
