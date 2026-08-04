part of '../home_screen.dart';

class _HealthScheduleCard extends StatelessWidget {
  const _HealthScheduleCard();

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '건강 일정',
      background: const MeshGradientBackground(
        baseColor: MyColor.white,
        colors: [
          MyColor.primary400,
          MyColor.primary500,
          MyColor.primary300,
        ],
        blurSigma: 32,
        topScrimAlpha: 0,
      ),
      content: Stack(
        fit: StackFit.expand,
        children: [
          FractionalTranslation(
            translation: const Offset(0.12, 0),
            child: Transform.scale(
              scale: 1.1,
              child: Image.asset(
                'assets/images/img_calendar.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: TextBtn(
                onTap: () {},
                text: '길 찾기',
                enable: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
