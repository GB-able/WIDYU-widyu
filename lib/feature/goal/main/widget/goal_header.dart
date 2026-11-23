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
          PointBanner(
            point: point,
            onTap: () => context.push(AppRoute.point.path),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonBox(
                width: 104,
                height: 26,
                lineHeight: 36,
                child: Text(
                  '${today.month}월 ${today.day}일',
                  style: MyTypo.title1.copyWith(color: MyColor.grey700),
                ),
              ),
              const SkeletonBox(
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
