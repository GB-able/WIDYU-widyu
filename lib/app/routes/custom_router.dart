import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_page.dart';
import 'package:widyu/core/ui/widgets/bot_nav.dart';
import 'package:widyu/feature/auth/login_screen.dart';
import 'package:widyu/feature/auth/onboarding_screen.dart';
import 'package:widyu/feature/contact/contact_screen.dart';
import 'package:widyu/feature/home/home_screen.dart';
import 'package:widyu/feature/management/management_screen.dart';
import 'package:widyu/feature/myPage/my_page_screen.dart';
import 'package:widyu/feature/notification/notification_screen.dart';
import 'package:widyu/feature/point/point_screen.dart';
import 'package:widyu/feature/profile/profile_screen.dart';
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
              builder: (context, state) => const HomeScreen(),
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
      CustomGoRoute.slideRoute(
        route: AppRoute.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.point,
        builder: (_, __) => const PointScreen(),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.contact,
        builder: (_, __) => const ContactScreen(),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.management,
        builder: (_, __) => const ManagementScreen(),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.notification,
        builder: (_, __) => const NotificationScreen(),
      ),
    ],
  );
}
