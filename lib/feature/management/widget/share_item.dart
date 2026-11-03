part of '../management_screen.dart';

class _ShareItem extends StatelessWidget {
  final SvgGenImage icon;
  final String label;
  final VoidCallback onTap;

  const _ShareItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: WiduIcon(icon: icon, width: 70, height: 70),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: MyTypo.subTitle2.copyWith(color: MyColor.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
