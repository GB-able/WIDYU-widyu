import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/models/api_result.dart';
import 'package:widyu/core/data/repositories/auth/auth_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/core/ui/widgets/text_btn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final result = await context.read<AuthRepositoryImpl>().logout();

    if (context.mounted) {
      switch (result) {
        case Success():
          context.go(AppRoute.onboarding.path);
        case Failure():
          showToast('로그아웃에 실패했습니다');
      }
    }
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
