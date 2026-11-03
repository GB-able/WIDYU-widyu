part of '../my_page_screen.dart';

class _TextMenu extends StatelessWidget {
  final String title;
  final SvgGenImage? asset;
  final VoidCallback onClick;

  const _TextMenu({
    required this.title,
    this.asset,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          child: Row(
            children: [
              if (asset != null) ...[
                WiduIcon(icon: asset!, width: 24, height: 24),
                const SizedBox(width: 8),
              ],
              Text(title, style: MyTypo.body1.copyWith(color: MyColor.black)),
              const Spacer(),
              WiduIcon(
                icon: Assets.icons.ic20ChevronRight,
                width: 20,
                height: 20,
                color: MyColor.grey400,
              )
            ],
          ),
        ),
      ),
    );
  }
}
