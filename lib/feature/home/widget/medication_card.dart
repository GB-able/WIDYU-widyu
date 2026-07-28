part of '../home_screen.dart';

class _MedicationCard extends StatelessWidget {
  const _MedicationCard();

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '약 복용',
      background: Container(color: MyColor.orange400),
      content: const SizedBox.shrink(),
    );
  }
}
