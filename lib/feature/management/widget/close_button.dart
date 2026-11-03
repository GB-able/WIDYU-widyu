part of '../management_screen.dart';

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColor.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: WiduIcon(
            icon: Assets.icons.ic16Close,
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }
}
