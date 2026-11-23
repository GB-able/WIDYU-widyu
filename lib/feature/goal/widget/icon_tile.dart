import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/gen/assets.gen.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.type, this.size = 40});

  final GoalType type;
  final double size;

  AssetGenImage get _image => switch (type) {
        GoalType.medicine => Assets.images.img40Medicine,
        GoalType.walk => Assets.images.img40Walk,
        GoalType.hospital => Assets.images.img40Hospital,
      };

  @override
  Widget build(BuildContext context) {
    // 디자인의 그림자는 40 크기에서 blur 5, 24 크기에서 blur 3이다.
    final scale = size / 40;
    return Skeleton.replace(
      width: size,
      height: size,
      replacement: Bone.circle(size: size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5 * scale,
              offset: Offset(scale, scale),
            ),
          ],
        ),
        child: ClipOval(
          child: _image.image(fit: BoxFit.cover),
        ),
      ),
    );
  }
}
