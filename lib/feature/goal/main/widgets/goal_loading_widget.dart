part of '../goal_screen.dart';

class _GoalLoadingWidget extends StatelessWidget {
  const _GoalLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 2),
          CircularProgressIndicator(color: MyColor.secondary),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
