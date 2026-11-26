part of '../home_screen.dart';

/// 홈 스켈레톤 공통 설정. 컨테이너는 원래 색과 그림자로 그리고 [Bone]만 칠한다.
class _HomeSkeletonizer extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const _HomeSkeletonizer({this.enabled = true, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      // 기기에서 동작 줄이기를 켜면 움직이지 않는 블록만 보여 준다.
      effect: MediaQuery.disableAnimationsOf(context)
          ? const SolidColorEffect(color: MyColor.grey200)
          : const WavePulseEffect(),
      child: child,
    );
  }
}

/// 줄 높이 [line] 안에 [width]×[height] 막대를 세로 가운데로 그린다.
Widget _skeletonBar(double width, double height, double line) => SizedBox(
      height: line,
      child: Align(
        alignment: Alignment.centerLeft,
        widthFactor: 1,
        child: Bone(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

/// 첫 진입 때 알림·인사·워치 카드 자리에 보여 줄 스켈레톤.
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  static Widget _watchCard(EdgeInsets padding, Widget child) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: MyColor.grey50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return _HomeSkeletonizer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              spacing: 12,
              children: [
                const Bone.circle(size: 24),
                _skeletonBar(169, 13, 17),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _skeletonBar(142, 11, 21),
          const SizedBox(height: 8),
          _skeletonBar(80, 16, 30),
          const SizedBox(height: 2),
          _skeletonBar(179, 11, 21),
          const SizedBox(height: 12),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: _watchCard(
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  Row(
                    spacing: 8,
                    children: [
                      const Bone.circle(size: 50),
                      _skeletonBar(47, 14, 27),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _watchCard(
                  const EdgeInsets.all(12),
                  Row(
                    spacing: 8,
                    children: [
                      const Bone.circle(size: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              _skeletonBar(32, 14, 27),
                              _skeletonBar(26, 10, 15),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.5),
                                child: _skeletonBar(23, 16, 22),
                              ),
                              _skeletonBar(21, 10, 15),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 캐러셀 카드 자리의 스켈레톤. 가운데 카드만 막대를 더 그린다.
class _CarouselSkeletonCard extends StatelessWidget {
  /// 시안의 카드별 제목 막대 폭. 0번이 첫 가운데, 1번이 오른쪽, 마지막이 왼쪽 카드.
  static const titleWidths = [68.0, 83.0, 60.0, 42.0];

  final double titleWidth;
  final bool isCentered;

  const _CarouselSkeletonCard({
    required this.titleWidth,
    required this.isCentered,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: MyColor.black.withValues(alpha: 0.2),
            offset: const Offset(1, 1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 29,
            child: _skeletonBar(titleWidth, 19, 19),
          ),
          if (isCentered) ...[
            Positioned(
              right: 20,
              top: 29,
              child: _skeletonBar(57, 19, 19),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 180,
              child: Center(child: _skeletonBar(50, 14, 14)),
            ),
          ],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Bone(
              height: 56,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ],
      ),
    );
  }
}

/// 캐러셀 인디케이터 자리의 점 4개.
class _CarouselSkeletonIndicator extends StatelessWidget {
  const _CarouselSkeletonIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: List.generate(
        _CarouselSkeletonCard.titleWidths.length,
        (_) => const Bone.circle(size: 6),
      ),
    );
  }
}
