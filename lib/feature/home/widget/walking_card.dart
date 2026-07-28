part of '../home_screen.dart';

class _WalkingCard extends StatelessWidget {
  const _WalkingCard();

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '걷기',
      background: Container(color: MyColor.green400),
      content: const SizedBox.shrink(),
    );
  }
}
