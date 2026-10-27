import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/core/storage/app_preference.dart';
import 'package:widyu/core/storage/preference_key.dart';
import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = SecureStorage();
  final _appPreference = AppPreference();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final fromDeepLink = CustomRouter.consumeDeepLinkLaunch();

    try {
      String? accessToken;
      try {
        accessToken = await _secureStorage.storage
            .read(key: StorageKey.widyuAccessToken.name)
            .timeout(const Duration(seconds: 3), onTimeout: () => null);
      } catch (e, stack) {
        debugPrint('[Splash] 토큰 읽기 실패, 온보딩으로 폴백: $e\n$stack');
        accessToken = null;
      }

      // 딥링크로 진입한 경우 온보딩을 건너뛰고 로그인 화면으로 보낸다.
      final nextPath = accessToken != null
          ? AppRoute.home.path
          : fromDeepLink
              ? AppRoute.login.path
              : AppRoute.onboarding.path;

      // 권한 안내 화면은 앱 최초 실행 시 1회만 노출한다.
      // 값이 없는 최초 실행은 [AppPreference] 의 기본값 false 로 내려와 안내가 뜨고,
      // 응답이 지연되는 경우에는 이미 안내를 본 사용자로 간주해 권한 화면을 건너뛴다.
      final permissionGuideShown = await _appPreference
          .getBool(PreferenceKey.permissionGuideShown)
          .timeout(const Duration(seconds: 3), onTimeout: () {
        debugPrint('[Splash] 권한 안내 노출 여부 읽기 지연, 권한 화면 생략');
        return true;
      });

      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      context.pushReplacement(
        permissionGuideShown
            ? nextPath
            : '${AppRoute.permission.path}?next=${Uri.encodeQueryComponent(nextPath)}',
      );
    } catch (e, stack) {
      debugPrint('[Splash] init 실패: $e\n$stack');
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
