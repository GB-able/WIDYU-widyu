part of '../home_screen.dart';

/// 자식을 스프링처럼 튕겨 확대했다가 원래 크기로 수렴시키는 래퍼.
///
/// [isActive] 가 false -> true 로 바뀌는 순간마다 바운스를 재생한다.
/// 위젯이 만들어질 때 이미 true 면 곧바로 재생하므로, 화면 진입 시점에
/// 중앙에 있던 카드도 별도 처리 없이 바운스한다.
class _SpringBounce extends StatefulWidget {
  /// 바운스 재생 조건. 이 값이 true 로 넘어오는 순간이 트리거다.
  final bool isActive;

  final Widget child;

  const _SpringBounce({required this.isActive, required this.child});

  @override
  State<_SpringBounce> createState() => _SpringBounceState();
}

class _SpringBounceState extends State<_SpringBounce>
    with SingleTickerProviderStateMixin {
  /// 감쇠비 약 0.4 의 저감쇠 스프링, 크게 한 번 튄 뒤 작게 한 번 되눌렸다가 멎는다
  static const _spring =
      SpringDescription(mass: 1, stiffness: 190, damping: 11);

  /// 바운스를 촉발하는 초기 속도
  static const _kickVelocity = 12.0;

  /// 컨트롤러 값을 확대 비율로 옮기는 계수
  /// 위 스프링에서 값의 최댓값이 약 0.57 이라 실제 최대 확대는 1.2배 남짓이다
  static const _scaleGain = 0.35;

  /// 화면 진입 시의 바운스를 첫 프레임 이후로 미루는 시간
  /// 홈 화면에서 처리하는 작업이 많아 프레임이 스킵될 수 있으므로 바운스 효과를 보여주기 위함
  static const _entryDelay = Duration(milliseconds: 400);

  late final AnimationController _controller;

  Timer? _entryTimer;

  /// 마운트 시점에 예약된 진입 바운스가 아직 재생되지 않았는지 여부
  bool _pendingEntryBounce = false;

  @override
  void initState() {
    super.initState();
    // 평상시 값은 0(=원래 크기)이고, 바운스 동안에만 0 주위를 진동한다.
    _controller = AnimationController.unbounded(vsync: this);
    _pendingEntryBounce = widget.isActive;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 티커가 꺼진 서브트리(전환 중 가려진 라우트, 비활성 탭 등)에서 재생하면
    // 시간만 흐르고 화면에는 남지 않으므로, 티커가 실제로 돌기 시작한 뒤 예약한다.
    if (_pendingEntryBounce && TickerMode.of(context)) {
      _pendingEntryBounce = false;
      _scheduleEntryBounce();
    }
  }

  void _scheduleEntryBounce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _entryTimer = Timer(_entryDelay, () {
        // 사이에 카드를 넘겨 버렸다면 더 이상 중앙이 아니므로 재생하지 않는다.
        if (mounted && widget.isActive) _bounce();
      });
    });
  }

  @override
  void didUpdateWidget(_SpringBounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _entryTimer?.cancel();
      _bounce();
    }
  }

  /// 이전 바운스가 남아 있으면 현재 위치와 속도를 이어받아,
  /// 카드를 빠르게 되넘길 때도 움직임이 끊기지 않게 한다.
  void _bounce() => _controller.animateWith(
        SpringSimulation(
          _spring,
          _controller.value,
          0,
          _controller.velocity + _kickVelocity,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => Transform.scale(
        scale: 1 + _controller.value * _scaleGain,
        child: child,
      ),
    );
  }
}
