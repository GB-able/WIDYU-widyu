import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? "",
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 0),
      placeholder: (context, url) =>
          Container(width: width, height: height, color: MyColor.grey100),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: MyColor.grey100,
        child: const Icon(Icons.image, color: MyColor.grey300, size: 48),
      ),
    );
  }
}
