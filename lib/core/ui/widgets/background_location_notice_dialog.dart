import 'package:flutter/material.dart';

/// 백그라운드 위치 공유에 필요한 '항상 허용' 상태를 한 번 안내한다.
class BackgroundLocationNoticeDialog extends StatelessWidget {
  const BackgroundLocationNoticeDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    if (!context.mounted) return false;
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (_) => const BackgroundLocationNoticeDialog(),
    );
    return shouldOpenSettings ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('위치 항상 허용이 필요해요'),
      content: const Text(
        '앱을 사용하지 않는 동안에도 보호자에게 내 위치를 공유하려면 위치 권한을 항상 허용으로 설정해 주세요.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('나중에'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('설정으로 이동'),
        ),
      ],
    );
  }
}
