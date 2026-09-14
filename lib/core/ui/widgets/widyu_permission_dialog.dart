import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';

class WidyuPermissionDialog extends StatelessWidget {
  final String description;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  const WidyuPermissionDialog({
    super.key,
    required this.description,
    required this.onConfirm,
    required this.onDismiss,
  });

  static Future<bool> show(
    BuildContext context, {
    required String description,
  }) async {
    if (!context.mounted) return false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => WidyuPermissionDialog(
        description: description,
        onConfirm: () => dialogContext.pop(true),
        onDismiss: () => dialogContext.pop(false),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColor.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const WidyuAssetImage(
              name: 'img_94_warning.png',
              width: 94,
              height: 94,
            ),
            const SizedBox(height: 8),
            Text(
              '서비스 이용을 위해\n권한이 필요해요',
              style: MyTypo.title1,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: MyTypo.body1.copyWith(color: MyColor.grey600),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: WidyuTextButton(
                    onTap: onDismiss,
                    text: '나중에 하기',
                    backgroundColor: MyColor.grey100,
                    textColor: MyColor.grey800,
                  ),
                ),
                Expanded(
                  child: WidyuTextButton(
                    onTap: onConfirm,
                    text: '설정으로 이동',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
