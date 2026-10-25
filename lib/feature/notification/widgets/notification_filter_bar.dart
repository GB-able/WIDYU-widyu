part of '../notification_screen.dart';

class _NotificationFilterBar extends StatelessWidget {
  const _NotificationFilterBar();

  @override
  Widget build(BuildContext context) {
    final uiState = context.watch<NotificationViewModel>().uiState;

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: uiState.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = uiState.categories[index];

          return _NotificationFilterChip(
            category: category,
            isSelected: uiState.category == category.label,
            onTap: () =>
                context.read<NotificationViewModel>().select(category.label),
          );
        },
      ),
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  const _NotificationFilterChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final NotificationCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? MyColor.grey700 : MyColor.grey100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.name,
              style: MyTypo.subTitle2.copyWith(
                color: isSelected ? MyColor.grey50 : MyColor.grey500,
              ),
            ),
            if (category.count > 0)
              Text(
                category.count > 99 ? "99+" : "${category.count}",
                style: MyTypo.subTitle2.copyWith(
                  color: isSelected ? MyColor.orange400 : MyColor.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
