import 'package:flutter/material.dart';
import 'package:widyu/core/theme/colors.dart';
import 'package:widyu/core/theme/typos.dart';

class TextBtn extends StatelessWidget {
  const TextBtn(
      {super.key,
      required this.onTap,
      required this.text,
      required this.enable});

  final VoidCallback? onTap;
  final String text;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: enable ? MyColor.primary : MyColor.grey100,
        ),
        width: double.infinity,
        height: 52,
        child: Container(
          alignment: Alignment.center,
          child: Text(text,
              style: MyTypo.button
                  .copyWith(color: enable ? MyColor.white : MyColor.grey300)),
        ),
      ),
    );
  }
}
