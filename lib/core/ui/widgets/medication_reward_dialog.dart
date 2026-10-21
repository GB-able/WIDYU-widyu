import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';

class MedicationRewardDialog extends StatelessWidget {
  const MedicationRewardDialog(
      {super.key, required this.earnedPoint, required this.currentPoint});

  final int earnedPoint;
  final int currentPoint;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColor.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColor.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const WidyuAssetImage(
                  name: 'img_125_check.png',
                  width: 125,
                  height: 125,
                ),
                const SizedBox(height: 16),
                Text(
                  '리워드 획득!',
                  style: MyTypo.title2.copyWith(color: MyColor.black),
                ),
                const SizedBox(height: 8),
                Text(
                  '${earnedPoint}P',
                  style: MyTypo.title1.copyWith(color: MyColor.primary),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.grey100,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '잔여 포인트',
                        style:
                            MyTypo.subTitle2.copyWith(color: MyColor.grey600),
                      ),
                      const Spacer(),
                      Text(
                        '${currentPoint}P',
                        style: MyTypo.title2.copyWith(color: MyColor.grey600),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Material(
                  type: MaterialType.transparency,
                  child: WidyuTextButton(
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.of(context).pop();
                      router.go(AppRoute.goal.path);
                    },
                    text: '목표로 이동하기',
                    enable: true,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _RewardCloseButton(
              onTap: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RewardCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColor.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: WidyuIcon(
            icon: 'ic_16_close.svg',
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }
}
