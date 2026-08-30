part of '../home_screen.dart';

class _HealthScheduleCard extends StatelessWidget {
  final bool isCentered;
  final VoidCallback onRouteTap;

  const _HealthScheduleCard({
    required this.isCentered,
    required this.onRouteTap,
  });

  /// 좌측 상단 모서리에서 카드 중심을 향해 타원형으로 늘어선 3개의 blob 궤도
  static const _healthScheduleBlobSpecs = <_BlobSpec>[
    _BlobSpec(
      centerX: 0.10,
      centerY: 0.12,
      amplitudeX: 0.04,
      amplitudeY: 0.04,
      freqX: 1,
      freqY: 1,
      phaseX: 0.00,
      phaseY: 0.28,
      radius: 0.46,
      opacity: 0.90,
      aspect: 1.20,
      angle: 0.22 * pi,
      wobble: 0.06,
    ),
    _BlobSpec(
      centerX: 0.32,
      centerY: 0.30,
      amplitudeX: 0.05,
      amplitudeY: 0.04,
      freqX: 1,
      freqY: 2,
      phaseX: 0.41,
      phaseY: 0.13,
      radius: 0.46,
      opacity: 0.85,
      aspect: 1.30,
      angle: 0.14 * pi,
      wobble: 0.08,
    ),
    _BlobSpec(
      centerX: 0.55,
      centerY: 0.48,
      amplitudeX: 0.05,
      amplitudeY: 0.05,
      freqX: 2,
      freqY: 1,
      phaseX: 0.67,
      phaseY: 0.72,
      radius: 0.42,
      opacity: 0.80,
      aspect: 1.12,
      angle: 0.32 * pi,
      wobble: 0.07,
    ),
  ];

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
        blobs: _healthScheduleBlobSpecs,
        blurSigma: 32,
        topScrimAlpha: 0,
      ),
      content: Stack(
        fit: StackFit.expand,
        children: [
          _SpringBounce(
            isActive: isCentered,
            child: FractionalTranslation(
              translation: const Offset(0.12, 0),
              child: Transform.scale(
                scale: 1.1,
                child: const WidyuAssetImage(
                  name: 'img_calendar.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: WidyuTextButton(
                onTap: onRouteTap,
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
