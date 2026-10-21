part of '../notification_screen.dart';

class _NotificationEmptyWidget extends StatelessWidget {
  const _NotificationEmptyWidget({
    required this.hasError,
    required this.onRetry,
  });

  final bool hasError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Text(
          hasError ? "알림을 불러오지 못했어요." : "현재 확인할 알림이 없어요.",
          style: MyTypo.title3.copyWith(color: MyColor.grey400),
        ),
        const SizedBox(height: 8),
        Text(
          hasError ? "잠시 후 다시 시도해 주세요." : "중요한 알림이 생기면 바로 알려드릴게요.",
          style: MyTypo.body2.copyWith(color: MyColor.grey300),
        ),
        if (hasError)
          TextButton(
            onPressed: onRetry,
            child: const Text(
              "다시 시도",
              style: TextStyle(color: MyColor.primary),
            ),
          ),
      ],
    );
  }
}
