import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_page.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/ui/widgets/bot_nav.dart';
import 'package:widyu/feature/auth/login_screen.dart';
import 'package:widyu/feature/auth/onboarding_screen.dart';
import 'package:widyu/feature/home/home_screen.dart';
import 'package:widyu/feature/myPage/my_page_screen.dart';
import 'package:widyu/feature/splash_screen.dart';

class CustomRouter {
  static final router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      CustomGoRoute.fadeRoute(
        route: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(routes: [
            CustomGoRoute.staticRoute(
              route: AppRoute.home,
              builder: (context, state) =>
                  HomeScreen(repository: context.read<AuthRepository>()),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.staticRoute(
              route: AppRoute.goal,
              builder: (context, state) => const Placeholder(),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.staticRoute(
              route: AppRoute.album,
              builder: (context, state) => const Placeholder(),
            ),
          ]),
          StatefulShellBranch(routes: [
            CustomGoRoute.staticRoute(
              route: AppRoute.my,
              builder: (context, state) => const MyPageScreen(),
            ),
          ]),
        ],
        builder: (context, state, navigationShell) => Stack(
          alignment: Alignment.bottomCenter,
          children: [navigationShell, const BotNav()],
        ),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
