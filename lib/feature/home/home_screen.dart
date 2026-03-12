import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/background_service.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/text_btn.dart';
import 'package:widyu/core/utils/extensions/location_service_state_extension.dart';
import 'package:widyu/core/utils/location_service_manager.dart';
import 'package:widyu/core/utils/show_toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<LocationServiceState>? _locationServiceState;

  Future<void> _handleLogout(BuildContext context) async {
    final result = await widget.repository.logout();

    if (!context.mounted) return;

    switch (result) {
      case Success():
        await stopBackgroundService();
        if (context.mounted) {
          context.go(AppRoute.onboarding.path);
        }
      case Failure():
        showToast('로그아웃에 실패했습니다');
    }
  }

  Future<void> _startBackgroundService() async {
    LocationServiceManager.startMonitoring();
    _locationServiceState =
        LocationServiceManager.locationServiceState.listen((state) async {
      final message = state.message;
      if (message != null) {
        showToast(message);
        await stopBackgroundService();
        return;
      }
      await startBackgroundService();
    });
  }

  @override
  void initState() {
    super.initState();
    _startBackgroundService();
  }

  @override
  void dispose() {
    _locationServiceState?.cancel();
    LocationServiceManager.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '홈 화면',
                style: MyTypo.title1.copyWith(color: MyColor.grey900),
              ),
              const SizedBox(height: 48),
              TextBtn(
                onTap: () => _handleLogout(context),
                text: '로그아웃',
                enable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
