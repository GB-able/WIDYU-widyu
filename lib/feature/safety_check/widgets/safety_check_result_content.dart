part of '../emergency_confirm_screen.dart';

class _EmergencyResultContent extends StatelessWidget {
  const _EmergencyResultContent({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        const WidyuAssetImage(
          name: 'img_125_check.png',
          width: 124,
          height: 124,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: MyTypo.subTitle6.copyWith(
            color: MyColor.white,
          ),
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: MyTypo.body1.copyWith(color: MyColor.white),
        ),
      ],
    );
  }
}
