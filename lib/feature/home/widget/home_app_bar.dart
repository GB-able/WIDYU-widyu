part of '../home_screen.dart';

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      backgroundColor: MyColor.transparent,
      titleSpacing: 16,
      title: Text(
        '위듀',
        style: MyTypo.kccTitle.copyWith(color: MyColor.black),
      ),
      actions: [
        GestureDetector(
          onTap: () => {},
          child: const WidyuIcon(
            icon: 'ic_24_notification.svg',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
