import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorIconSize = 48,
    this.decodeWidth,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double errorIconSize;
  final int? decodeWidth;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _error();

    return LayoutBuilder(
      builder: (context, constraints) => CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: decodeWidth ?? _decodeWidth(context, constraints),
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _error(),
      ),
    );
  }

  int? _decodeWidth(BuildContext context, BoxConstraints constraints) {
    final sides = [
      width ?? constraints.maxWidth,
      height ?? constraints.maxHeight,
    ].where((side) => side.isFinite && side > 0);
    if (sides.isEmpty) return null;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return (sides.reduce(math.max) * pixelRatio).round();
  }

  Widget _placeholder() =>
      Container(width: width, height: height, color: MyColor.grey100);

  Widget _error() => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        color: MyColor.grey100,
        child: Icon(Icons.image, color: MyColor.grey300, size: errorIconSize),
      );
}
