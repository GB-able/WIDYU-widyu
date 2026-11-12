part of '../goal_screen.dart';

class _GoalContent extends StatelessWidget {
  const _GoalContent({
    required this.state,
    required this.onRetry,
    required this.onMedicationVerified,
    required this.findRoute,
  });

  final GoalCardsState state;
  final VoidCallback onRetry;
  final ValueChanged<MedicationPointResult> onMedicationVerified;
  final VoidCallback findRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        24,
        16,
        100 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: switch (state) {
        GoalCardsLoading() => const SizedBox.shrink(),
        GoalCardsError() => Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: _GoalErrorWidget(onRetry: onRetry),
          ),
        GoalCardsData(
          :final medicine,
          :final walk,
          :final hospital,
          :final proofPhoto,
        ) =>
          Column(
            spacing: 16,
            children: [
              medicine != null
                  ? MedicationCard(
                      medicine: medicine,
                      proofPhoto: proofPhoto,
                      onVerified: onMedicationVerified,
                    )
                  : const GoalEmptyCard(type: GoalType.medicine),
              walk != null && walk.goal > 0
                  ? Consumer(
                      builder: (context, ref, _) => WalkCard(
                        walk: walk.copyWith(
                          actual: ref.watch(todayStepsProvider),
                        ),
                      ),
                    )
                  : const GoalEmptyCard(type: GoalType.walk),
              hospital != null
                  ? HospitalCard(
                      hospital: hospital,
                      onTap: () {},
                      findRoute: findRoute,
                    )
                  : const GoalEmptyCard(type: GoalType.hospital),
            ],
          ),
      },
    );
  }
}
