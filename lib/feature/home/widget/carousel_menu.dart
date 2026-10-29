part of '../home_screen.dart';

enum _CarouselCard { medication, healthSchedule, walking, album }

class _CarouselMenu extends StatefulWidget {
  final bool isLoading;
  final bool hasGoal;
  final List<String> thumbanils;
  final MedicationStatus medicationStatus;
  final bool hasStepGoal;
  final double stepProgress;
  final bool hasHealthSchedule;
  final VoidCallback onCameraTap;
  final VoidCallback onRouteTap;

  const _CarouselMenu({
    required this.isLoading,
    required this.hasGoal,
    required this.thumbanils,
    required this.medicationStatus,
    required this.hasStepGoal,
    required this.stepProgress,
    required this.hasHealthSchedule,
    required this.onCameraTap,
    required this.onRouteTap,
  });

  static const sheetRadius = _CarouselMenuState._sheetRadius;

  static double sheetHeightOf(BuildContext context) =>
      _CarouselMenuState._carouselTopPadding +
      _CarouselMenuState._carouselCardMaxHeight +
      _CarouselMenuState._carouselIndicatorArea +
      BotNav.height +
      MediaQuery.paddingOf(context).bottom;

  @override
  State<_CarouselMenu> createState() => _CarouselMenuState();
}

class _CarouselMenuState extends State<_CarouselMenu> {
  PageController? _controller;

  // 무한 순환을 위해 양방향으로 충분한 여유를 둔 시작 페이지
  // 인덱스는 이 페이지를 0으로 두고 계산하므로 카드 수가 몇 개든 첫 인디케이터가 0을 가리킨다
  static const _carouselInitialPage = 4000;
  static const _carouselTopPadding = 32.0;
  static const _carouselArcOffset = 40.0;
  static const _carouselMaxAngle = 0.12;
  static const _carouselCardGap = 52.0;
  static const _carouselCardWidth = 220.0;
  static const _carouselCardMaxHeight = 278.0;
  static const _carouselCardMinScale = 0.6;
  static const _sheetRadius = 40.0;

  static const _carouselIndicatorGap = 20.0;
  static const _carouselIndicatorSize = 6.0;
  static const _carouselBottomPadding = 16.0;
  static const _carouselIndicatorArea =
      _carouselIndicatorGap + _carouselIndicatorSize + _carouselBottomPadding;

  /// 현재 중앙에 있는 페이지
  int _currentPage = _carouselInitialPage;

  /// 데이터가 있는 카드만 순환 대상에 넣는다.
  List<_CarouselCard> get _cards => [
        _CarouselCard.medication,
        if (widget.hasHealthSchedule) _CarouselCard.healthSchedule,
        _CarouselCard.walking,
        _CarouselCard.album,
      ];

  int _indexAt(int page, int length) => (page - _carouselInitialPage) % length;

  /// [page] 위치에 놓일 카드. 중앙 카드에만 아이콘 바운스를 켠다.
  Widget _cardAt(int page, List<_CarouselCard> cards) {
    final isCentered = page == _currentPage;
    return switch (cards[_indexAt(page, cards.length)]) {
      _CarouselCard.medication => _MedicationCard(
          medicationStatus: widget.medicationStatus,
          onCameraTap: widget.onCameraTap,
          isCentered: isCentered,
        ),
      _CarouselCard.healthSchedule => _HealthScheduleCard(
          isCentered: isCentered,
          onRouteTap: widget.onRouteTap,
        ),
      _CarouselCard.walking => _WalkingCard(
          hasStepGoal: widget.hasStepGoal,
          stepProgress: widget.stepProgress,
        ),
      _CarouselCard.album => _AlbumCard(thumbnails: widget.thumbanils),
    };
  }

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
    final cards = _cards;
    final bottomPadding =
        BotNav.height + MediaQuery.paddingOf(context).bottom + 16;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = (constraints.maxHeight -
                _carouselTopPadding -
                _carouselIndicatorArea -
                bottomPadding)
            .clamp(_carouselCardMaxHeight * _carouselCardMinScale,
                _carouselCardMaxHeight);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: _carouselTopPadding,
            bottom: bottomPadding,
          ),
          decoration: const BoxDecoration(
            color: MyColor.grey100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_sheetRadius),
              topRight: Radius.circular(_sheetRadius),
            ),
          ),
          child: _content(controller, cards, cardHeight),
        );
      },
    );
  }

  Widget _content(
      PageController controller, List<_CarouselCard> cards, double cardHeight) {
    final contentHeight = cardHeight + _carouselIndicatorArea;

    // 로딩
    if (widget.isLoading) {
      return SizedBox(
        height: contentHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 목표가 존재하지 않음
    if (!widget.hasGoal) {
      return SizedBox(
        height: contentHeight,
        child: const _CarouselEmptyView(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView.builder(
            controller: controller,
            clipBehavior: Clip.none,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final page = controller.hasClients && controller.page != null
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
                    width: _carouselCardWidth *
                        cardHeight /
                        _carouselCardMaxHeight,
                    height: cardHeight,
                    child: FittedBox(
                      child: SizedBox(
                        width: _carouselCardWidth,
                        height: _carouselCardMaxHeight,
                        child: GestureDetector(
                          onTap: () => controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          ),
                          child: _cardAt(index, cards),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: _carouselIndicatorGap),
        _CarouselIndicator(
          count: cards.length,
          currentIndex: _indexAt(_currentPage, cards.length),
        ),
        const SizedBox(height: _carouselBottomPadding),
      ],
    );
  }
}

class _CarouselEmptyView extends StatelessWidget {
  const _CarouselEmptyView();

  static const _characterWidth = 144.0;
  static const _characterHeight = 186.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Expanded(
            child: Assets.images.imgCardCharacter.image(
              width: _characterWidth,
              height: _characterHeight,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '목표가 없어요!',
            style: MyTypo.title2.copyWith(color: MyColor.grey700),
          ),
          const SizedBox(height: 8),
          Text(
            '목표를 추가하고 건강을 위해 실천해 보세요.',
            style: MyTypo.body2.copyWith(color: MyColor.grey500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          WidyuTextButton(
            onTap: () => context.go(AppRoute.goal.path),
            text: '+   목표 추가하기',
            backgroundColor: MyColor.white,
            textColor: MyColor.primary,
          ),
        ],
      ),
    );
  }
}
