part of '../goal_screen.dart';

class _GoalLoadingWidget extends StatelessWidget {
  const _GoalLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Column(
        children: [
          Spacer(flex: 2),
          CircularProgressIndicator(),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
