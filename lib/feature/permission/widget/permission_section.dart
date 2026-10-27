part of '../permission_screen.dart';

class _PermissionSection extends StatelessWidget {
  final String title;
  final List<PermissionType> permissions;

  const _PermissionSection({required this.title, required this.permissions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyTypo.subTitle7.copyWith(color: MyColor.primary),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: List.generate(
            permissions.length,
            (index) => _PermissionItem(permission: permissions[index]),
          ),
        ),
      ],
    );
  }
}
