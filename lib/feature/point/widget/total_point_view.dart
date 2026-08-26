part of '../point_screen.dart';

class _TotalPointView extends StatelessWidget {
  final int amount;

  const _TotalPointView({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyColor.primaryLight,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          const WidyuAssetImage(
            name: 'img_28_point.png',
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 4),
          Text(
            '포인트',
            style: MyTypo.subTitle5.copyWith(color: MyColor.grey800),
          ),
          const Spacer(),
          Text(
            '${amount}P',
            style: MyTypo.title4.copyWith(color: MyColor.primary),
          ),
        ],
      ),
    );
  }
}
