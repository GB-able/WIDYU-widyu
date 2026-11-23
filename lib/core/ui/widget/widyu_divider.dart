import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class WidyuDivider extends StatelessWidget {
  final double height;

  const WidyuDivider({super.key, this.height = 10});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 10,
      child: DecoratedBox(
        decoration: BoxDecoration(color: MyColor.grey50),
      ),
    );
  }
}
