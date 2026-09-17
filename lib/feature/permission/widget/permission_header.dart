part of '../permission_screen.dart';

class _PermissionHeader extends StatelessWidget {
  const _PermissionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '위듀 앱 이용을 위한 권한 안내',
          style: MyTypo.title2.copyWith(color: MyColor.grey800),
        ),
      ],
    );
  }
}
