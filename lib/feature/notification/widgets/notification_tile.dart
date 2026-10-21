part of '../notification_screen.dart';

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final NotificationItemUiModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        color: notification.isRead ? MyColor.white : MyColor.orange50,
        padding: const EdgeInsets.all(16),
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/img_24_warning.png",
              width: 24,
              height: 24,
            ),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.group.title,
                    style: MyTypo.body2.copyWith(color: MyColor.grey500),
                  ),
                  Text(
                    notification.title,
                    style: MyTypo.subTitle3.copyWith(color: MyColor.grey800),
                    overflow: TextOverflow.visible,
                  ),
                  if (notification.content.isNotEmpty)
                    Text(
                      notification.content,
                      style: MyTypo.body2.copyWith(color: MyColor.grey600),
                      overflow: TextOverflow.visible,
                    ),
                ],
              ),
            ),
            Text(
              notification.createdAt.shortTimeAgo,
              style: MyTypo.helper2.copyWith(color: MyColor.grey600),
            ),
          ],
        ),
      ),
    );
  }
}
