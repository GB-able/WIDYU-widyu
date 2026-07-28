part of '../home_screen.dart';

class _HealthScheduleCard extends StatelessWidget {
  const _HealthScheduleCard();

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '건강 일정',
      background: Container(color: MyColor.purple400),
      content: const SizedBox.shrink(),
    );
  }
}
