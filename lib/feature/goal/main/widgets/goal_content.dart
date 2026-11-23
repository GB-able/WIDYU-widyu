part of '../goal_screen.dart';

class _GoalContent extends StatelessWidget {
  const _GoalContent({
    required this.state,
    required this.onRetry,
    required this.onMedicationVerified,
    required this.findRoute,
  });

  final GoalUiState state;
  final VoidCallback onRetry;
  final ValueChanged<MedicationPointResult> onMedicationVerified;
  final ValueChanged<DailyHealthSchedule> findRoute;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const SizedBox.shrink();
    if (state.hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: _GoalErrorWidget(onRetry: onRetry),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle('오늘의 스케줄'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _ScheduleTimeline(
            medicine: state.medicine,
            visits: state.visits,
            onMedicationVerified: onMedicationVerified,
            findRoute: findRoute,
          ),
        ),
        if (state.hasStepGoal) ...[
          const SizedBox(height: 16),
          const _SectionTitle('오늘의 걸음 수'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: _StepSummary(goal: state.stepGoal),
          ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: MyTypo.title4.copyWith(color: MyColor.grey700),
      ),
    );
  }
}

class _StepSummary extends StatelessWidget {
  const _StepSummary({required this.goal});

  final int goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColor.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const IconTile(type: GoalType.walk, size: 24),
          const SizedBox(width: 16),
          Text('걷기', style: MyTypo.subTitle5.copyWith(color: MyColor.grey700)),
          const Spacer(),
          // 걸음 수는 자주 바뀌므로 숫자만 다시 그린다.
          Consumer(
            builder: (context, ref, _) => Text(
              ref.watch(todayStepsProvider).toComma,
              style: MyTypo.subTitle1.copyWith(color: MyColor.primary),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '/ ${goal.toComma}',
            style: MyTypo.subTitle1.copyWith(color: MyColor.grey500),
          ),
        ],
      ),
    );
  }
}
