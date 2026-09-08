import 'package:flutter/material.dart';

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

  void _close(BuildContext context, PermissionRecoveryAction action) {
    Navigator.of(context).pop(action);
  }

  @override
  Widget build(BuildContext context) {
    final isSettingsMode = mode == PermissionRecoveryMode.settings;

    // TODO: Replace this basic dialog with the product-specific permission design.
    return AlertDialog(
      title: Text(
        isSettingsMode ? '$permissionName 권한 설정' : '$permissionName 권한이 필요해요',
      ),
      content: Text(
        isSettingsMode
            ? '$description\n\n이 권한은 앱 설정에서 허용할 수 있어요.'
            : description,
      ),
      actions: [
        TextButton(
          onPressed: () => _close(context, PermissionRecoveryAction.cancel),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => _close(
            context,
            isSettingsMode
                ? PermissionRecoveryAction.openSettings
                : PermissionRecoveryAction.retry,
          ),
          child: Text(isSettingsMode ? '설정으로 이동' : '계속'),
        ),
      ],
    );
  }
}
