part of '../goal_screen.dart';

/// 조회 중에 보여 줄 가짜 스케줄. 바깥 [Skeletonizer]가 글자와 카드를 블록으로 바꾼다.
class _GoalSkeleton extends StatelessWidget {
  const _GoalSkeleton();

  static const _address = '서울 성북구 고려대로 73';

  // 일정 제목 줄 높이(24)는 그대로 두고 블록만 시안 크기로 그린다.
  static Widget _bone(double width, double height) => SizedBox(
        height: 24,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Bone(
            width: width,
            height: height,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );

  static GoalTimelineItem _row(TimelineStatus status, double titleWidth,
          {String? subtitle}) =>
      GoalTimelineItem(
        status: status,
        leading: const Bone.circle(size: 24),
        title: _bone(titleWidth, 16),
        subtitle: subtitle,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('오늘의 스케줄'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GoalTimeline(
            items: [
              _row(TimelineStatus.missed, 110),
              _row(TimelineStatus.done, 150, subtitle: _address),
              _row(TimelineStatus.done, 120),
              GoalTimelineItem(
                status: TimelineStatus.active,
                leading: const Bone.circle(size: 40),
                title: _bone(140, 18),
                subtitle: _address,
                action: Bone(
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              _row(TimelineStatus.upcoming, 110),
              _row(TimelineStatus.upcoming, 120),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SectionTitle('오늘의 걸음 수'),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: _StepSummary(goal: 10000),
        ),
      ],
    );
  }
}

/// 스켈레톤일 때 [child] 대신 시안 크기의 블록을 그린다. 평소에는 [child]를 그대로 그린다.
///
/// 블록이 글자보다 낮아도 줄 높이는 [lineHeight]로 유지해, 로딩이 끝날 때 화면이 밀리지 않게 한다.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.lineHeight,
    required this.child,
    this.pill = false,
  });

  final double width;
  final double height;
  final double lineHeight;
  final bool pill;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeleton.replace(
      width: width,
      height: lineHeight,
      replacement: Center(
        child: Bone(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(pill ? height / 2 : 6),
        ),
      ),
      child: child,
    );
  }
}
