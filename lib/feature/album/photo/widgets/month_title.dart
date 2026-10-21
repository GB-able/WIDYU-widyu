part of '../photo_tab_view.dart';

class _MonthTitle extends StatelessWidget {
  const _MonthTitle({required this.month});

  final String month;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(month, style: MyTypo.body1),
        ),
      ],
    );
  }
}
