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
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double errorIconSize;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _error();

    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => _placeholder(),
      errorWidget: (context, url, error) => _error(),
    );
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
