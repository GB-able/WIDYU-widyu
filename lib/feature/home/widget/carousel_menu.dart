part of '../home_screen.dart';

/// 무한 순환을 위해 양방향으로 충분한 여유를 둔 시작 페이지
/// 첫 인디케이터가 0을 가리키려면 [_carouselCards] 길이의 배수여야 한다
const _carouselInitialPage = 4000;
const _cardsLength = 4;
const _carouselArcOffset = 40.0;
const _carouselMaxAngle = 0.12;
const _carouselCardGap = 52.0;
const _carouselCardWidth = 220.0;
const _carouselCardMaxHeight = 278.0;

// 인디케이터 영역 높이 (카드와의 간격 20 + 인디케이터 크기 6 + 하단 여백 16)
const _carouselIndicatorArea = 42.0;

class _CarouselMenu extends StatefulWidget {
  final List<String> thumbanils;
  final int todayTakenCount;
  final int todayTotalCount;
  final Duration nextDoseRemainingTime;
  final double stepProgress;

  const _CarouselMenu({
    required this.thumbanils,
    required this.todayTakenCount,
    required this.todayTotalCount,
    required this.nextDoseRemainingTime,
    required this.stepProgress,
  });

  @override
  State<_CarouselMenu> createState() => _CarouselMenuState();
}

class _CarouselMenuState extends State<_CarouselMenu> {
  PageController? _controller;

  int _currentIndex = _carouselInitialPage % _cardsLength;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;

    final width = MediaQuery.sizeOf(context).width;
    _controller = PageController(
      viewportFraction:
          ((_carouselCardWidth + _carouselCardGap) / width).clamp(0.5, 1.0),
      initialPage: _carouselInitialPage,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    final cards = <Widget>[
      _MedicationCard(),
      _HealthScheduleCard(),
      _WalkingCard(),
      _AlbumCard(thumbnails: widget.thumbanils),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 32,
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardHeight = (constraints.maxHeight - _carouselIndicatorArea)
              .clamp(0.0, _carouselCardMaxHeight);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: cardHeight,
                child: PageView.builder(
                  controller: controller,
                  clipBehavior: Clip.none,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index % cards.length),
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        final page =
                            controller.hasClients && controller.page != null
                                ? controller.page!
                                : controller.initialPage.toDouble();
                        final delta = (page - index).clamp(-1.0, 1.0);

                        return Transform.translate(
                          offset: Offset(0, delta * delta * _carouselArcOffset),
                          child: Transform.rotate(
                            angle: -delta * _carouselMaxAngle,
                            alignment: Alignment.topCenter,
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: _carouselCardWidth,
                          height: cardHeight,
                          child: GestureDetector(
                            onTap: () => controller.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            ),
                            child: cards[index % cards.length],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _CarouselIndicator(
                count: cards.length,
                currentIndex: _currentIndex,
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
