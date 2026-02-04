import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/data/repositories/auth/auth_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/text_btn.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/show_toast.dart';

import '../../background_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleLogout(BuildContext context) async {
    final result = await widget.repository.logout();

    if (context.mounted) {
      switch (result) {
        case Success():
          stopBackgroundService();
          context.go(AppRoute.onboarding.path);
        case Failure():
          showToast('로그아웃에 실패했습니다');
      }
    }
  }

  Future<void> _startBackgroundService() async {
    if (!await PermissionManager.checkLocationPermission()) {
      Fluttertoast.showToast(msg: "권한이 거절되어 위치 추적 기능이 제한됩니다.");
      return;
    }
    startBackgroundService();
  }

  @override
  void initState() {
    super.initState();
    _startBackgroundService();
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
