import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';

import '../../core/utils/local_notification_manager.dart';
import '../../core/utils/location_service_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currIdx = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currIdx = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasLocationPermission =
          await LocationServiceManager.checkLocationPermission();
      final hasNotificationPermission =
          await LocalNotificationManager.hasPermission();
      if (!mounted) return;
      if (!hasLocationPermission || !hasNotificationPermission) {
        _showPermissionDialog();
      }
    });
  }

  /*
    다이얼로그 디자인 및 플로우 개선 필요
    1. 권한 상태 확인 후 권한 안내 다이얼로그 출력
    2. 알림 권한 요청
    3. 위치 권한 요청
    4. 백그라운드 위치 접근에 대한 안내 다이얼로그 (취소 버튼 및 설정 이동 버튼 존재)
    5. 취소 혹은 설정 창으로 이동한 뒤 권한을 거절한 경우 기능 제한 안내 토스트 메시지 출력
  */

  Future<void> _showPermissionDialog() {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("권한 안내"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text("안내 본문"),
            TextButton(
              onPressed: () async {
                GoRouter.of(dialogContext).pop();
                // 위치 권한은 '항상 허용' 단계에서 설정 화면으로 이탈할 수 있으므로,
                // 앱 안에서 끝나는 알림 권한을 먼저 요청한다.
                await LocalNotificationManager.requestPermission();
                await LocationServiceManager.requestLocationPermission();
              },
              child: const Text("권한 버튼"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: 5,
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    _onPageChanged(index);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: WidyuAssetImage(
                            name: 'img_300_onboarding_1.png',
                            height: double.infinity,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Text(
                        "함께 나누고, 더 건강하게.",
                        style: MyTypo.title2.copyWith(color: MyColor.grey800),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 8),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          index == _currIdx ? MyColor.grey500 : MyColor.grey100,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: WidyuTextButton(
                onTap: () {
                  context.push(AppRoute.login.path);
                },
                text: '시작하기',
                enable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
