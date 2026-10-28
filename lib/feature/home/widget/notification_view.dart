part of '../home_screen.dart';

class _NotificationView extends StatelessWidget {
  final int id;
  final AssetGenImage? icon;
  final String description;
  final ValueChanged<int> onTap;

  const _NotificationView({
    required this.id,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap.call(id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon?.image(width: 24, height: 24) ??
                const SizedBox(width: 24, height: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MyTypo.body1.copyWith(color: MyColor.grey900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
