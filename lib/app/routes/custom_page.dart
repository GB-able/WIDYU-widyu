import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';

extension CustomGoRoute on GoRoute {
  static const duration = Duration(milliseconds: 100);

  static GoRoute slideRoute({
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
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
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
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: builder(context, state),
      ),
    );
  }
}
