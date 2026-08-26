part of '../home_screen.dart';

/// 배경(full-bleed)과 콘텐츠(사방 20 여백) 2층 구조의 공통 카드 껍데기.
/// 제목만 공통이고 배경·콘텐츠는 각 카드가 채운다.
class _CarouselCardShell extends StatelessWidget {
  final String title;
  final Widget background;
  final Widget content;

  const _CarouselCardShell({
    required this.title,
    required this.background,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        fit: StackFit.expand,
        children: [
          background,
          Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                content,
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: MyTypo.title1.copyWith(color: MyColor.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
