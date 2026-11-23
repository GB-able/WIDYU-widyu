import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// 스켈레톤일 때 [child] 대신 시안 크기의 블록을 그린다. 평소에는 [child]를 그대로 그린다.
///
/// 블록이 글자보다 낮아도 줄 높이는 [lineHeight]로 유지해, 로딩이 끝날 때 화면이 밀리지 않게 한다.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    required this.lineHeight,
    required this.child,
    this.pill = false,
  });

  final double width;
  final double height;
  final double lineHeight;
  final bool pill;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Skeleton.replace는 스켈레톤이 꺼져 있어도 크기를 고정하므로 직접 나눈다.
    if (Skeletonizer.maybeOf(context)?.enabled != true) return child;
    return SizedBox(
      width: width,
      height: lineHeight,
      child: Center(
        child: Bone(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(pill ? height / 2 : 6),
        ),
      ),
    );
  }
}
