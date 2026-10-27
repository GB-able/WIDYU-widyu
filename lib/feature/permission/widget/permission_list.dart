part of '../permission_screen.dart';

class _PermissionList extends StatelessWidget {
  final List<PermissionType> requiredPermissions;
  final List<PermissionType> optionalPermissions;

  const _PermissionList({
    required this.requiredPermissions,
    required this.optionalPermissions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: [
        if (requiredPermissions.isNotEmpty)
          _PermissionSection(
            title: '필수 접근 권한',
            permissions: requiredPermissions,
          ),
        if (optionalPermissions.isNotEmpty)
          _PermissionSection(
            title: '선택 접근 권한',
            permissions: optionalPermissions,
          ),
      ],
    );
  }
}
