import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class FeedLockOverlay extends StatelessWidget {
  const FeedLockOverlay({super.key, required this.price, required this.child});

  final int price;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 24,
              sigmaY: 24,
              tileMode: TileMode.clamp,
            ),
            child: child,
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: MyColor.black.withValues(alpha: 0.4),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              WiduIcon(icon: Assets.icons.ic60Lock, width: 60),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Text(
                  '${price}P',
                  style: MyTypo.percentage.copyWith(color: MyColor.grey500),
                ),
              ),
              Text(
                '소식을 구매하고\n가족들의 일상을 둘러보세요',
                style: MyTypo.subTitle3.copyWith(color: MyColor.grey200),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MediaLockOverlay extends StatelessWidget {
  const MediaLockOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
              tileMode: TileMode.clamp,
            ),
            child: child,
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: MyColor.black.withValues(alpha: 0.4),
          child: WiduIcon(icon: Assets.icons.ic40Lock, width: 40),
        ),
      ],
    );
  }
}
