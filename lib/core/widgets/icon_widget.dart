import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconWidget extends StatelessWidget {
  const IconWidget(
      {super.key,
      required this.icon,
      required this.width,
      this.height,
      this.color});
  final String icon;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/ic_${width!.toInt()}_$icon.svg",
      width: width,
      height: height,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
