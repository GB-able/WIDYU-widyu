part of '../notification_screen.dart';

class _NotificationEmptyWidget extends StatelessWidget {
  const _NotificationEmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Text(
          '현재 확인할 알림이 없어요.',
          style: MyTypo.title2.copyWith(color: MyColor.grey300),
        ),
        const SizedBox(height: 8),
        Text(
          '중요한 알림이 생기면 바로 알려드릴게요.',
          style: MyTypo.body1.copyWith(color: MyColor.grey300),
        ),
      ],
    );
  }
}
