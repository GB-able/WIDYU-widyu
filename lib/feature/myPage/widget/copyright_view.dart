part of '../my_page_screen.dart';

class _CopyrightView extends StatelessWidget {
  const _CopyrightView();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Assets.icons.ic7Copyright.svg(width: 7.7, height: 7.7),
        Text(
          '2026. Gbable. All Rights Reserved',
          style: MyTypo.helper3.copyWith(color: MyColor.grey500),
        ),
      ],
    );
  }
}
