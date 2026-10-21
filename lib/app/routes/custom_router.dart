import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_page.dart';
import 'package:widyu/app/routes/extra/edit_post_extra.dart';
import 'package:widyu/app/routes/extra/photo_preview_extra.dart';
import 'package:widyu/app/routes/tab_reloader.dart';
import 'package:widyu/app/routes/user_session_scope.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/ui/widgets/bot_nav.dart';
import 'package:widyu/feature/album/album_screen.dart';
import 'package:widyu/feature/album/manage_post/manage_post_screen.dart';
import 'package:widyu/feature/album/post/post_screen.dart';
import 'package:widyu/feature/album/preview/photo_preview_screen.dart';
import 'package:widyu/feature/album/select_photo/select_photo_screen.dart';
import 'package:widyu/feature/auth/login_screen.dart';
import 'package:widyu/feature/auth/onboarding_screen.dart';
import 'package:widyu/feature/contact/contact_screen.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/feature/goal/medication/medication_session_scope.dart';
import 'package:widyu/feature/medication_camera/medication_camera_screen.dart';
import 'package:widyu/feature/home/home_screen.dart';
import 'package:widyu/feature/management/management_screen.dart';
import 'package:widyu/feature/myPage/my_page_screen.dart';
import 'package:widyu/feature/notification/notification_screen.dart';
import 'package:widyu/feature/notification_setting/notification_setting_screen.dart';
import 'package:widyu/feature/permission/permission_screen.dart';
import 'package:widyu/feature/point/point_screen.dart';
import 'package:widyu/feature/profile/profile_screen.dart';
import 'package:widyu/feature/splash_screen.dart';

class CustomRouter {
  static bool _initialRedirectHandled = false;

  static bool _launchedFromDeepLink = false;

  static bool consumeDeepLinkLaunch() {
    final launchedFromDeepLink = _launchedFromDeepLink;
    _launchedFromDeepLink = false;
    return launchedFromDeepLink;
  }

  static final router = GoRouter(
    initialLocation: AppRoute.splash.path,
    redirect: (context, state) async {
      if (!_initialRedirectHandled) {
        _initialRedirectHandled = true;
        if (state.uri.path != AppRoute.splash.path) {
          _launchedFromDeepLink = true;
          return AppRoute.splash.path;
        }
      }

      final isPublic = {
        AppRoute.splash.path,
        AppRoute.permission.path,
        AppRoute.onboarding.path,
        AppRoute.login.path,
      }.contains(state.uri.path);
      if (!isPublic && !await TokenManager().hasToken()) {
        return AppRoute.onboarding.path;
      }
      return null;
    },
    onException: (context, state, router) {
      debugPrint('[Router] 매칭되는 경로 없음: ${state.uri}');
      router.go(AppRoute.splash.path);
    },
    routes: [
      CustomGoRoute.fadeRoute(
        route: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      CustomGoRoute.fadeRoute(
        route: AppRoute.permission,
        builder: (context, state) => PermissionScreen(
          nextPath:
              state.uri.queryParameters['next'] ?? AppRoute.onboarding.path,
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
      ShellRoute(
        builder: (context, state, child) => UserSessionScope(
          child: MedicationSessionScope(child: child),
        ),
        routes: [
          CustomGoRoute.closeRoute(
            route: AppRoute.medicationCamera,
            builder: (_, state) => state.extra is Map
                ? MedicationCameraScreen(
                    group: Map<String, dynamic>.from(state.extra as Map))
                : const Scaffold(
                    body: Center(child: Text('복용 정보를 확인할 수 없어요.'))),
          ),
          StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                routes: [
                  CustomGoRoute.staticRoute(
                    route: AppRoute.home,
                    builder: (context, state) =>
                        TabReloader.wrap(index: 0, child: const HomeScreen()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  CustomGoRoute.staticRoute(
                    route: AppRoute.goal,
                    builder: (context, state) =>
                        TabReloader.wrap(index: 1, child: const GoalScreen()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  CustomGoRoute.staticRoute(
                    route: AppRoute.album,
                    builder: (context, state) =>
                        TabReloader.wrap(index: 2, child: const AlbumScreen()),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  CustomGoRoute.staticRoute(
                    route: AppRoute.my,
                    builder: (context, state) =>
                        TabReloader.wrap(index: 3, child: const MyPageScreen()),
                  ),
                ],
              ),
            ],
            builder: (context, state, navigationShell) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                navigationShell,
                BotNav(navigationShell: navigationShell),
              ],
            ),
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
            route: AppRoute.notificationSetting,
            builder: (_, __) => const NotificationSettingScreen(),
          ),
          CustomGoRoute.slideRoute(
            route: AppRoute.notification,
            builder: (_, __) => const NotificationScreen(),
          ),
          CustomGoRoute.slideRoute(
            route: AppRoute.post,
            builder: (_, state) => PostScreen(albumId: state.extra as int),
          ),
          CustomGoRoute.closeRoute(
            route: AppRoute.selectPhoto,
            builder: (_, __) => const SelectPhotoScreen(),
          ),
          CustomGoRoute.slideRoute(
            route: AppRoute.photoPreview,
            builder: (_, state) =>
                PhotoPreviewScreen(extra: state.extra as PhotoPreviewExtra),
          ),
          CustomGoRoute.slideRoute(
            route: AppRoute.managePost,
            builder: (_, state) {
              final extra = state.extra;
              return extra is EditPostExtra
                  ? ManagePostScreen.modify(extra: extra)
                  : ManagePostScreen.create(
                      photos: (extra as List).cast<AssetEntity>(),
                    );
            },
          ),
        ],
      ),
    ],
  );
}
