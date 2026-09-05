import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class DoneTag extends StatelessWidget {
  const DoneTag({super.key, required this.isFailed});

  final bool isFailed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isFailed ? MyColor.red200 : MyColor.green200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isFailed ? "미완료" : "완료",
        style: MyTypo.subTitle3.copyWith(
          color: isFailed ? MyColor.red500 : MyColor.green600,
        ),
      ),
    );
  }
}
