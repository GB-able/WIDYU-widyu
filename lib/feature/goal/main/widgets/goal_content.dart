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
            child: Consumer(
              builder: (context, ref, _) => WalkDonutCard(
                actual: ref.watch(todayStepsProvider),
                goal: state.stepGoal,
                color: MyColor.grey50,
              ),
            ),
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
