part of '../select_photo_screen.dart';

class _PhotoHeader extends StatelessWidget implements PreferredSizeWidget {
  const _PhotoHeader({required this.filter, required this.setFilter});

  final PhotoFilter filter;
  final Function(PhotoFilter) setFilter;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.white,
      elevation: 0,
      centerTitle: true,
      leading: const SizedBox.shrink(),
      title: PopupMenuButton<PhotoFilter>(
        onSelected: setFilter,
        offset: const Offset(-24, 36),
        color: MyColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        itemBuilder: (context) => PhotoFilter.values
            .map(
              (f) => PopupMenuItem(
                value: f,
                child: Text(
                  f.label,
                  style: MyTypo.body1.copyWith(
                    color: f == filter ? MyColor.primary : MyColor.grey800,
                  ),
                ),
              ),
            )
            .toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(
              filter.label,
              style: MyTypo.tab.copyWith(color: MyColor.black),
            ),
            const IconWidget(icon: 'chevron_down', width: 14),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => context.pop(),
          child: const IconWidget(
            icon: 'close',
            width: 24,
            color: MyColor.grey600,
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 16),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
