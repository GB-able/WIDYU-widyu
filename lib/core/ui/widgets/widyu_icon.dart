import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WidyuIcon extends StatelessWidget {
  final String icon;
  final double? width;
  final double? height;
  final Color? color;

  const WidyuIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$icon',
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
