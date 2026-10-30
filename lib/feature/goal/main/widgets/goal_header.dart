part of '../goal_screen.dart';

class _GoalHeader extends StatelessWidget {
  const _GoalHeader({super.key, required this.summary, required this.point});

  final List<GoalRateStatus>? summary;
  final int? point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        spacing: 24,
        children: [
          _PointBanner(point: point),
          _WeeklyCard(summary: summary ?? const []),
        ],
      ),
    );
  }
}

class _PointBanner extends StatelessWidget {
  const _PointBanner({required this.point});

  final int? point;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoute.point.path),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: MyColor.orange50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Assets.images.img28Point.image(width: 28, height: 28),
            const SizedBox(width: 4),
            Text(
              '포인트',
              style: MyTypo.subTitle5.copyWith(color: MyColor.grey800),
            ),
            const Spacer(),
            Text(
              '${point ?? "-"}P',
              style: MyTypo.title4.copyWith(color: MyColor.primary),
            ),
          ],
        ),
      ),
    );
  }
}
