part of '../safety_check_screen.dart';

class _SlideButton extends StatefulWidget {
  const _SlideButton({required this.onCompleted});

  final Future<bool> Function() onCompleted;

  @override
  State<_SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<_SlideButton>
    with SingleTickerProviderStateMixin {
  static const _height = 56.0;
  static const _thumbSize = 46.0;
  static const _thumbInset = 6.0;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  bool _completed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxOffset) {
    if (_completed) return;
    _controller.value += details.primaryDelta! / maxOffset;
  }

  void _animateBack() => _controller.animateBack(0, curve: Curves.easeOutCubic);

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_completed) return;
    final isFling = (details.primaryVelocity ?? 0) > 1000;
    if (_controller.value < 0.8 && !isFling) {
      _animateBack();
      return;
    }
    _completed = true;
    HapticFeedback.vibrate();
    _controller.animateTo(1, curve: Curves.easeOutCubic);
    final succeeded = await widget.onCompleted();
    if (succeeded || !mounted) return;
    _completed = false;
    _animateBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxOffset = constraints.maxWidth - _thumbSize - _thumbInset * 2;
        return Container(
          width: constraints.maxWidth,
          height: _height,
          decoration: const ShapeDecoration(
            color: MyColor.primary,
            shape: StadiumBorder(),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity: ReverseAnimation(_controller),
                child: Text(
                  '밀어서 취소하기',
                  style: MyTypo.title3.copyWith(color: MyColor.white),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: Offset(
                      _thumbInset + _controller.value * maxOffset,
                      0,
                    ),
                    child: child,
                  ),
                ),
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onDragUpdate(details, maxOffset),
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: MyColor.primary50,
                      shape: BoxShape.circle,
                    ),
                    child: const WidyuIcon(
                      icon: 'ic_24_chevron_right.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
