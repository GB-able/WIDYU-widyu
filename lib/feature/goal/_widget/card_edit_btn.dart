import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';

class CardEditBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CardEditBtn({super.key, this.label = '수정하기', required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: Material(
        color: MyColor.grey50,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidyuIcon(
                icon: 'ic_18_edit.svg',
                width: 18,
                height: 18,
                color: MyColor.grey700,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: MyTypo.subTitle2.copyWith(color: MyColor.grey700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
