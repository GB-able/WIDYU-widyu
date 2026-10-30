import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, this.profileImage, this.size = 40});

  final String? profileImage;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = profileImage;

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: url == null || url.isEmpty
            ? _placeholder
            : CachedNetworkImage(
                imageUrl: url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                placeholder: (_, __) => _placeholder,
                errorWidget: (_, __, ___) => _placeholder,
              ),
      ),
    );
  }

  Widget get _placeholder => WiduIcon(
        icon: Assets.icons.ic76Profile,
        width: size,
        height: size,
      );
}
