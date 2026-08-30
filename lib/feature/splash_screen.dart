import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/core/storage/secure_storage.dart';
import 'package:widyu/core/storage/storage_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = SecureStorage();

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
            .read(key: StorageKey.accessToken.name)
            .timeout(const Duration(seconds: 3), onTimeout: () => null);
      } catch (e, stack) {
        debugPrint('[Splash] 토큰 읽기 실패, 온보딩으로 폴백: $e\n$stack');
        accessToken = null;
      }

      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      // 딥링크로 진입한 경우 온보딩을 건너뛰고 로그인 화면으로 보낸다.
      context.pushReplacement(
        accessToken != null
            ? AppRoute.home.path
            : fromDeepLink
                ? AppRoute.login.path
                : AppRoute.onboarding.path,
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
