part of '../goal_screen.dart';

class _GoalHeader extends StatelessWidget {
  const _GoalHeader({required this.point});

  final int? point;

  @override
  Widget build(BuildContext context) {
    final today = clock.now();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 32,
        children: [
          _PointBanner(point: point),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SkeletonBox(
                width: 104,
                height: 26,
                lineHeight: 36,
                child: Text(
                  '${today.month}월 ${today.day}일',
                  style: MyTypo.title1.copyWith(color: MyColor.grey700),
                ),
              ),
              const _SkeletonBox(
                width: 96,
                height: 36,
                lineHeight: 36,
                pill: true,
                child: _MonthlyGoalButton(onTap: null),
              ),
            ],
          ),
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
            Skeleton.replace(
              width: 28,
              height: 28,
              replacement: const Center(child: Bone.circle(size: 26)),
              child: Assets.images.img28Point.image(width: 28, height: 28),
            ),
            const SizedBox(width: 4),
            _SkeletonBox(
              width: 52,
              height: 16,
              lineHeight: 24,
              child: Text(
                '포인트',
                style: MyTypo.subTitle5.copyWith(color: MyColor.grey800),
              ),
            ),
            const Spacer(),
            _SkeletonBox(
              width: 56,
              height: 20,
              lineHeight: 27,
              child: Text(
                '${point ?? "-"}P',
                style: MyTypo.title4.copyWith(color: MyColor.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyGoalButton extends StatelessWidget {
  const _MonthlyGoalButton({required this.onTap});

  // TODO: 월간 목표 화면(#142)이 생기면 이동을 연결한다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColor.orange50,
          border: Border.all(color: MyColor.primary),
          borderRadius: BorderRadius.circular(10000),
        ),
        child: Text(
          '월간 목표',
          style: MyTypo.subTitle3.copyWith(color: MyColor.primary),
        ),
      ),
    );
  }
}
