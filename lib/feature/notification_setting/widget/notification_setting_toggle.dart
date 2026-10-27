part of '../notification_setting_screen.dart';

class _NotificationSettingToggle extends StatelessWidget {
  final NotificationSettingUiModel notification;
  final bool isUpdating;
  final ValueChanged<NotificationSettingUiModel> onToggle;

  const _NotificationSettingToggle({
    required this.notification,
    required this.isUpdating,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.group.name,
              style: MyTypo.body1.copyWith(color: MyColor.grey900),
            ),
            const SizedBox(height: 2),
            Text(
              notification.group.description,
              style: MyTypo.helper.copyWith(color: MyColor.grey500),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: 50,
          height: 30,
          child: Switch(
            value: notification.enabled,
            onChanged: isUpdating
                ? null
                : (value) => onToggle(notification.copyWith(enabled: value)),
            activeTrackColor: MyColor.primary,
            inactiveTrackColor: MyColor.grey200,
            thumbColor: WidgetStateProperty.all(MyColor.white),
            thumbIcon: WidgetStateProperty.all(const Icon(null)),
            trackOutlineColor: WidgetStateProperty.all(MyColor.transparent),
            overlayColor: WidgetStateProperty.all(MyColor.transparent),
          ),
        )
      ],
    );
  }
}
