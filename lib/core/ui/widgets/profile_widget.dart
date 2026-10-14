import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';

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

  Widget get _placeholder => WidyuIcon(
        icon: 'ic_76_profile.svg',
        width: size,
        height: size,
      );
}
