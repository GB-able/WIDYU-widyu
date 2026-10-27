import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

enum CustomDialogType { one, two }

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.type = CustomDialogType.one,
    required this.title,
    this.description,
    this.posText = '확인',
    this.negText = '취소',
    this.onPosTap,
    this.onNegTap,
  });

  final CustomDialogType type;
  final String title;
  final String? description;
  final String posText;
  final String negText;
  final VoidCallback? onPosTap;
  final VoidCallback? onNegTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColor.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: MyTypo.title3.copyWith(color: MyColor.grey800),
                    textAlign: TextAlign.center,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      style: MyTypo.body2.copyWith(color: MyColor.grey500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: MyColor.grey100),
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  if (type == CustomDialogType.two) ...[
                    Expanded(
                      child: _DialogAction(
                        label: negText,
                        color: MyColor.grey500,
                        onTap: () {
                          Navigator.pop(context);
                          onNegTap?.call();
                        },
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: MyColor.grey100,
                    ),
                  ],
                  Expanded(
                    child: _DialogAction(
                      label: posText,
                      color: MyColor.primary,
                      onTap: () {
                        Navigator.pop(context);
                        onPosTap?.call();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogAction extends StatelessWidget {
  const _DialogAction({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        child: Text(label, style: MyTypo.button.copyWith(color: color)),
      ),
    );
  }
}
