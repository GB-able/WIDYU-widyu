part of '../medication_camera_screen.dart';

class _MedicationCameraAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _MedicationCameraAppBar({required this.enabled});

  final bool enabled;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _scrimColor,
      systemOverlayStyle: _systemOverlayStyle,
      title: Text(
        '약 인증하기',
        style: MyTypo.title4.copyWith(color: MyColor.white),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: enabled ? () => context.pop() : null,
        icon: WiduIcon(
          icon: Assets.icons.ic24ArrowLeftBold,
          width: 24,
          height: 24,
          color: MyColor.white,
        ),
      ),
    );
  }
}
