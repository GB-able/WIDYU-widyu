import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/skeleton_box.dart';
import 'package:widyu/gen/assets.gen.dart';

/// 포인트 아이콘·문구와 현재 포인트를 보여 주는 주황 배너. 목표 화면과 포인트 화면이 함께 쓴다.
class PointBanner extends StatelessWidget {
  const PointBanner({super.key, required this.point, this.onTap});

  final int? point;

  /// 없으면 누를 수 없는 배너가 된다.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: MyColor.orange50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Skeleton.replace(
              width: 28,
              height: 28,
              replacement: const Center(child: Bone.circle(size: 26)),
              child: Assets.images.img28Point.image(width: 28, height: 28),
            ),
            const SizedBox(width: 4),
            SkeletonBox(
              width: 52,
              height: 16,
              lineHeight: 24,
              child: Text(
                '포인트',
                style: MyTypo.subTitle5.copyWith(color: MyColor.grey800),
              ),
            ),
            const Spacer(),
            SkeletonBox(
              width: 56,
              height: 20,
              lineHeight: 27,
              child: Text(
                '${point ?? "-"}P',
                style: MyTypo.title4.copyWith(color: MyColor.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
