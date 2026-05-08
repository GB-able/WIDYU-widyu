part of '../my_page_screen.dart';

class _TextMenu extends StatelessWidget {
  final String title;
  final VoidCallback onClick;

  const _TextMenu({
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
    );
  }
}
