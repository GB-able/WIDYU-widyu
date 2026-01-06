import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/storage/secure_storage.dart';

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
    final accessToken =
        await _secureStorage.storage.read(key: StorageKey.accessToken.name);
    if (mounted) {
      if (accessToken == null) {
        context.pushReplacement(AppRoute.onboarding.path);
      } else {
        context.pushReplacement(AppRoute.home.path);
      }
      await Future.delayed(const Duration(milliseconds: 1500));
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
