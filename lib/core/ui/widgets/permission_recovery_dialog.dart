import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_dialog.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';

import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';

/// 권한 요청을 다시 안내하고 사용자의 다음 선택만 반환하는 dialog.
class PermissionRecoveryDialog extends StatelessWidget {
  final String permissionName;
  final String description;
  final PermissionRecoveryMode mode;

  const PermissionRecoveryDialog({
    super.key,
    required this.permissionName,
    required this.description,
    required this.mode,
  });

  static Future<PermissionRecoveryAction> show(
    BuildContext context, {
    required String permissionName,
    required String description,
    required PermissionRecoveryMode mode,
  }) async {
    if (!context.mounted) {
      return PermissionRecoveryAction.cancel;
    }

    final result = await showDialog<PermissionRecoveryAction>(
      context: context,
      builder: (_) => PermissionRecoveryDialog(
        permissionName: permissionName,
        description: description,
        mode: mode,
      ),
    );
    return result ?? PermissionRecoveryAction.cancel;
  }

  void _close(
    BuildContext context,
    PermissionRecoveryAction action,
  ) {
    context.pop(action);
  }

  @override
  Widget build(BuildContext context) {
    final isSettingsMode = mode == PermissionRecoveryMode.settings;

    return WidyuDialog(
      contentPadding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WidyuAssetImage(
              name: 'img_94_warning.png',
              width: 94,
              height: 94,
            ),
            const SizedBox(height: 8),
            Text(
              isSettingsMode
                  ? '$permissionName 권한 설정'
                  : '$permissionName 권한이 필요해요',
              style: MyTypo.title1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSettingsMode
                  ? '$description\n\n이 권한은 앱 설정에서 허용할 수 있어요.'
                  : description,
              style: MyTypo.body1.copyWith(color: MyColor.grey600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: WidyuTextButton(
                    onTap: () =>
                        _close(context, PermissionRecoveryAction.cancel),
                    text: '취소',
                    backgroundColor: MyColor.grey100,
                    textColor: MyColor.grey800,
                  ),
                ),
                Expanded(
                  child: WidyuTextButton(
                    onTap: () => _close(
                      context,
                      isSettingsMode
                          ? PermissionRecoveryAction.openSettings
                          : PermissionRecoveryAction.retry,
                    ),
                    text: isSettingsMode ? '설정으로 이동' : '계속',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
