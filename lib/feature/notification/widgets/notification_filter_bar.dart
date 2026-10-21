part of '../notification_screen.dart';

class _NotificationFilterBar extends StatelessWidget {
  const _NotificationFilterBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: NotificationFilter.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = NotificationFilter.values[index];

          return _NotificationFilterChip(
            filter: filter,
            count: viewModel.uiState.countOf(filter),
            isSelected: viewModel.uiState.filter == filter,
            onTap: () => context.read<NotificationViewModel>().select(filter),
          );
        },
      ),
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  const _NotificationFilterChip({
    required this.filter,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final NotificationFilter filter;
  final int count;
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
              filter.label,
              style: MyTypo.subTitle2.copyWith(
                color: isSelected ? MyColor.grey50 : MyColor.grey500,
              ),
            ),
            if (count > 0)
              Text(
                count > 99 ? "99+" : "$count",
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
