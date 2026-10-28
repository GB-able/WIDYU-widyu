part of '../permission_screen.dart';

class _PermissionItem extends StatelessWidget {
  final PermissionType permission;

  const _PermissionItem({required this.permission});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: MyColor.grey200,
            shape: BoxShape.circle,
          ),
          child: WiduIcon(
            icon: permission.icon,
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permission.title,
                style: MyTypo.subTitle2.copyWith(color: MyColor.grey800),
              ),
              const SizedBox(height: 2),
              Text(
                permission.description,
                style: MyTypo.helper.copyWith(color: MyColor.grey600),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
