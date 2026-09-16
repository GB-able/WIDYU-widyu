part of '../home_screen.dart';

class _CarouselMenu extends StatefulWidget {
  final bool isLoading;
  final bool hasGoal;
  final List<String> thumbanils;
  final MedicationStatus medicationStatus;
  final bool hasStepGoal;
  final double stepProgress;
  final VoidCallback onCameraTap;
  final VoidCallback onRouteTap;

  const _CarouselMenu({
    required this.isLoading,
    required this.hasGoal,
    required this.thumbanils,
    required this.medicationStatus,
    required this.hasStepGoal,
    required this.stepProgress,
    required this.onCameraTap,
    required this.onRouteTap,
  });

  /// 시트 위 모서리 반지름. 배경 이미지가 모서리 영역까지 덮도록 홈 화면 레이아웃 계산에 쓴다.
  static const sheetRadius = _CarouselMenuState._sheetRadius;

  /// 카드 상태 기준 시트 높이. 홈 화면에서 배경 이미지 높이를 계산할 때 쓴다.
  static double sheetHeightOf(BuildContext context) =>
      _CarouselMenuState._sheetTopPadding +
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
  // 첫 인디케이터가 0을 가리키려면 [_carouselCards] 길이의 배수여야 한다
  static const _carouselInitialPage = 4000;
  static const _cardsLength = 4;
  static const _carouselArcOffset = 40.0;
  static const _carouselMaxAngle = 0.12;
  static const _carouselCardGap = 52.0;
  static const _carouselCardWidth = 220.0;
  static const _carouselCardMaxHeight = 278.0;
  static const _sheetTopPadding = 32.0;
  static const _sheetRadius = 40.0;

  // 인디케이터 영역 높이 (카드와의 간격 20 + 인디케이터 크기 6 + 하단 여백 16)
  static const _carouselIndicatorArea = 42.0;

  /// 현재 중앙에 있는 페이지
  int _currentPage = _carouselInitialPage;

  int get _currentIndex => _currentPage % _cardsLength;

  /// [page] 위치에 놓일 카드. 중앙 카드에만 아이콘 바운스를 켠다.
  Widget _cardAt(int page) {
    final isCentered = page == _currentPage;
    return switch (page % _cardsLength) {
      0 => _MedicationCard(
          medicationStatus: widget.medicationStatus,
          onCameraTap: widget.onCameraTap,
          isCentered: isCentered,
        ),
      1 => _HealthScheduleCard(
          isCentered: isCentered,
          onRouteTap: widget.onRouteTap,
        ),
      2 => _WalkingCard(
          hasStepGoal: widget.hasStepGoal,
          stepProgress: widget.stepProgress,
        ),
      _ => _AlbumCard(thumbnails: widget.thumbanils),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: _sheetTopPadding,
        bottom: BotNav.height + MediaQuery.paddingOf(context).bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_sheetRadius),
          topRight: Radius.circular(_sheetRadius),
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    final controller = _controller!;
    const cardHeight = _carouselCardMaxHeight;

    // 로딩
    if (widget.isLoading) {
      return const SizedBox(
        height: cardHeight + _carouselIndicatorArea,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // 목표가 존재하지 않음
    if (!widget.hasGoal) return const _CarouselEmptyView();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
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
                    width: _carouselCardWidth,
                    height: cardHeight,
                    child: GestureDetector(
                      onTap: () => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      ),
                      child: _cardAt(index),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _CarouselIndicator(
          count: _cardsLength,
          currentIndex: _currentIndex,
        ),
        const SizedBox(height: 16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const WidyuAssetImage(
            name: 'img_card_character.png',
            width: _characterWidth,
            height: _characterHeight,
            fit: BoxFit.contain,
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
