part of '../notification_screen.dart';

class _NotificationSettingView extends StatelessWidget {
  final List<NotificationUiModel> notifications;
  final ValueChanged<NotificationUiModel> onToggle;

  const _NotificationSettingView({
    required this.notifications,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '위듀 알림',
          style: MyTypo.title3.copyWith(color: MyColor.grey900),
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            notifications.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _NotificationToggle(
                notification: notifications[index],
                onToggle: onToggle,
              ),
            ),
          ),
        )
      ],
    );
  }
}
