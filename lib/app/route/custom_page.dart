import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/route/app_route.dart';

extension CustomGoRoute on GoRoute {
  static const duration = Duration(milliseconds: 100);

  static GoRoute slideRoute({
    required AppRoute route,
    required Widget Function(BuildContext, GoRouterState) builder,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: route.path,
      name: route.name,
      routes: routes,
      pageBuilder: (context, state) =>
          SlidePage(key: state.pageKey, child: builder(context, state)),
    );
  }

  static GoRoute closeRoute({
    required AppRoute route,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration duration = duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: route.path,
      name: route.name,
      routes: routes,
      pageBuilder: (context, state) =>
          _closePage(state, builder(context, state), duration),
    );
  }

  static ShellRoute closeShellRoute({
    required Widget Function(BuildContext, GoRouterState, Widget) builder,
    required List<RouteBase> routes,
    Duration duration = duration,
  }) {
    return ShellRoute(
      routes: routes,
      pageBuilder: (context, state, child) =>
          _closePage(state, builder(context, state, child), duration),
    );
  }

  static Page<void> _closePage(
    GoRouterState state,
    Widget child,
    Duration duration,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }

  static GoRoute fadeRoute({
    required AppRoute route,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration duration = duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: route.path,
      name: route.name,
      routes: routes,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  static GoRoute staticRoute({
    required AppRoute route,
    required Widget Function(BuildContext, GoRouterState) builder,
    Duration duration = duration,
    List<RouteBase> routes = const [],
  }) {
    return GoRoute(
      path: route.path,
      name: route.name,
      routes: routes,
      // 들어올 때는 움직이지 않고, 위에 slideRoute가 쌓이면 왼쪽으로 밀려난다.
      pageBuilder: (context, state) => SlidePage(
        key: state.pageKey,
        slideIn: false,
        child: builder(context, state),
      ),
    );
  }
}

/// 오른쪽에서 밀려 들어오는 화면 전환. 끝에서 천천히 멈추게 해 끊겨 보이지 않게 한다.
///
/// 들어오는 동안 이전 화면은 왼쪽으로 조금 밀려나며 어두워지고, 뒤로 가면 반대로 돌아온다.
/// [slideIn]이 false면 들어올 때는 움직이지 않고 밀려나는 효과만 쓴다(탭 첫 화면 등).
class SlidePage<T> extends Page<T> {
  const SlidePage({required this.child, this.slideIn = true, super.key});

  final Widget child;
  final bool slideIn;

  @override
  Route<T> createRoute(BuildContext context) => _SlideRoute<T>(this);
}

class _SlideRoute<T> extends PageRoute<T> {
  _SlideRoute(SlidePage<T> page) : super(settings: page);

  static const _duration = Duration(milliseconds: 320);
  static const _curve = Cubic(0.32, 0.72, 0, 1);

  /// 이전 화면이 밀려나는 거리(화면 너비 비율)와 어두워지는 정도(밝기 88%).
  static const _pushedBackOffset = Offset(-0.28, 0);
  static const _dimOpacity = 0.12;

  SlidePage<T> get _page => settings as SlidePage<T>;

  @override
  Duration get transitionDuration => _page.slideIn ? _duration : Duration.zero;

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  // 카메라(아래에서 올라옴)·페이드 화면이 위에 쌓일 때는 밀려나지 않는다.
  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is _SlideRoute && nextRoute._page.slideIn;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      _page.child;

  // buildTransitions는 프레임마다 불리므로 곡선 애니메이션은 한 번만 만들어 둔다.
  CurvedAnimation? _curvedIn;
  CurvedAnimation? _curvedBack;

  // 뒤로 갈 때도 처음엔 빠르고 끝에서 느려지게 곡선을 뒤집어 쓴다.
  // 스와이프로 뒤로 가는 중에는 손가락을 그대로 따라가도록 곡선을 쓰지 않는다.
  Animation<double> _curved(Animation<double> parent, CurvedAnimation curved) =>
      navigator?.userGestureInProgress ?? false ? parent : curved;

  static CurvedAnimation _curveOf(Animation<double> parent) => CurvedAnimation(
        parent: parent,
        curve: _curve,
        reverseCurve: _curve.flipped,
      );

  @override
  void dispose() {
    _curvedIn?.dispose();
    _curvedBack?.dispose();
    super.dispose();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final pushedBack = _curved(
      secondaryAnimation,
      _curvedBack ??= _curveOf(secondaryAnimation),
    );
    // 위 화면이 덮는 만큼 왼쪽으로 밀리고 어두워진다.
    final page = SlideTransition(
      position: pushedBack.drive(
        Tween(begin: Offset.zero, end: _pushedBackOffset),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          IgnorePointer(
            child: FadeTransition(
              opacity: pushedBack.drive(Tween(begin: 0, end: _dimOpacity)),
              child: const ColoredBox(color: Colors.black),
            ),
          ),
        ],
      ),
    );
    // 탭 첫 화면처럼 밀려 들어오지 않는 화면은 스와이프로 뒤로 가지 않는다.
    if (!_page.slideIn) return page;
    return SlideTransition(
      position: _curved(animation, _curvedIn ??= _curveOf(animation)).drive(
        Tween(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: _BackSwipe(route: this, child: page),
    );
  }

  /// 끈 거리(화면 너비 비율)만큼 화면을 되돌린다.
  void _dragBack(double fraction) => controller!.value -= fraction;

  /// 스와이프를 놓은 뒤 남은 거리를 마저 움직인다. 뒤로 가기로 했으면 pop한다.
  /// [cancelled]면(전화·시스템 제스처 등으로 포인터가 취소되면) 제자리로 돌린다.
  void _finishBackSwipe(double velocity, {bool cancelled = false}) {
    final controller = this.controller!;
    final navigator = this.navigator!;
    final bool stay;
    if (!isCurrent) {
      // 끄는 중에 다른 화면이 위에 쌓였으면 제자리로, 이미 닫히는 중이면 마저 닫는다.
      stay = isActive;
    } else if (cancelled || popDisposition == RoutePopDisposition.doNotPop) {
      // 끄는 중에 PopScope가 막았으면 닫지 않는다.
      stay = true;
    } else {
      // 화면 너비 기준 초당 1배 이상으로 튕기면 방향을 따르고, 아니면 절반을 기준으로 정한다.
      stay = velocity.abs() >= 1 ? velocity <= 0 : controller.value > 0.5;
    }
    final remaining = stay ? 1 - controller.value : controller.value;
    final duration = _duration * remaining.clamp(0.3, 1.0);

    if (stay) {
      controller.animateTo(1, duration: duration, curve: Curves.easeOut);
    } else {
      if (isCurrent) navigator.pop();
      if (controller.isAnimating) {
        controller.animateBack(0, duration: duration, curve: Curves.easeOut);
      }
    }

    // 움직임이 끝날 때까지 제스처 중으로 두어 도중에 곡선이 바뀌어 튀지 않게 한다.
    if (controller.isAnimating) {
      late AnimationStatusListener onStatus;
      onStatus = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(onStatus);
      };
      controller.addStatusListener(onStatus);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

/// 화면 어디서든 오른쪽으로 끌어 뒤로 간다. 안쪽의 가로 스크롤(달력 넘기기 등)이 먼저 이긴다.
class _BackSwipe extends StatefulWidget {
  const _BackSwipe({required this.route, required this.child});

  final _SlideRoute<dynamic> route;
  final Widget child;

  @override
  State<_BackSwipe> createState() => _BackSwipeState();
}

class _BackSwipeState extends State<_BackSwipe> {
  late final HorizontalDragGestureRecognizer _recognizer;
  bool _dragging = false;

  // 포인터가 취소돼도 recognizer는 onEnd를 부르므로 취소 여부를 따로 기록한다.
  // Listener가 recognizer보다 먼저 이벤트를 받는다.
  bool _pointerCancelled = false;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _onStart
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd
      ..onCancel = _onCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    // 끄는 도중에 화면이 사라지면 제스처 상태를 풀어 준다.
    if (_dragging) widget.route.navigator?.didStopUserGesture();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerCancelled = false;
    // 첫 화면, PopScope로 막힌 화면, 전환 중인 화면에서는 시작하지 않는다.
    if (widget.route.popGestureEnabled) _recognizer.addPointer(event);
  }

  void _onStart(DragStartDetails details) {
    _dragging = true;
    widget.route.navigator!.didStartUserGesture();
  }

  void _onUpdate(DragUpdateDetails details) {
    widget.route._dragBack(details.primaryDelta! / context.size!.width);
  }

  void _onEnd(DragEndDetails details) {
    _dragging = false;
    widget.route._finishBackSwipe(
      details.velocity.pixelsPerSecond.dx / context.size!.width,
      cancelled: _pointerCancelled,
    );
  }

  void _onCancel() {
    if (!_dragging) return;
    _dragging = false;
    widget.route._finishBackSwipe(0, cancelled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerCancel: (_) => _pointerCancelled = true,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
