part of '../home_screen.dart';

class _CarouselIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _CarouselIndicator({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: List.generate(
        count,
        (index) {
          final isSelected = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isSelected ? MyColor.primary : MyColor.grey400,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}
