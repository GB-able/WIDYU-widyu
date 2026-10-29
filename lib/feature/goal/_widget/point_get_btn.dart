import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/gen/assets.gen.dart';

class PointGetBtn extends StatelessWidget {
  final int point;
  final VoidCallback onTap;

  const PointGetBtn({super.key, required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        color: MyColor.grey50,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Assets.images.img20Point.image(
                width: 20,
                height: 20,
              ),
              Text(
                '${point}P 획득하기',
                style: MyTypo.subTitle2.copyWith(color: MyColor.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
