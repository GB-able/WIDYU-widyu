import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_page.dart';
import 'package:widyu/feature/auth/onboarding_screen.dart';

class CustomRouter {
  static final router = GoRouter(
    initialLocation: AppRoute.onboarding.path,
    routes: [
      CustomGoRoute.slideRoute(
        route: AppRoute.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}
