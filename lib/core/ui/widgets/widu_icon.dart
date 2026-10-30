import 'package:flutter/material.dart';
import 'package:widyu/gen/assets.gen.dart';

class WiduIcon extends StatelessWidget {
  final SvgGenImage icon;
  final double? width;
  final double? height;
  final Color? color;

  const WiduIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return icon.svg(
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
