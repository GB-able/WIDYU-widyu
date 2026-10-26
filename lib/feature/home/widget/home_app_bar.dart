part of '../home_screen.dart';

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasUnreadNotification;
  final VoidCallback onNotificationTap;

  const _HomeAppBar({
    required this.hasUnreadNotification,
    required this.onNotificationTap,
  });

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
          onTap: onNotificationTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const IconWidget(
                icon: 'notification',
                width: 22,
                height: 22,
                color: MyColor.black,
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: MyColor.red600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
