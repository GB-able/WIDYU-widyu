part of '../home_screen.dart';

/// 블러 처리된 색 덩어리(blob)들이 서로 다른 궤도로 떠다니는 mesh gradient 배경
/// [baseColor] 위에 [colors] 의 색상이 순서대로 blob 에 배정되며,
/// blob 개수가 색상 수보다 많으면 색상을 순환해서 사용한다.
/// 블러는 레이어 합성 비용이 큰 `BackdropFilter` 대신 [MaskFilter.blur] 로 처리한다.
class MeshGradientBackground extends StatefulWidget {
  /// blob 뒤에 깔리는 베이스 배경색
  final Color baseColor;

  /// blob에 사용할 색상 목록
  final List<Color> colors;

  /// blob 경계를 뭉개는 블러 강도
  final double blurSigma;

  /// blob이 궤도를 한 바퀴 도는 데 걸리는 시간
  final Duration duration;

  /// 상단에 얹는 어두운 스크림의 투명도. 흰색 제목의 가독성을 위해 사용한다.
  final double topScrimAlpha;

  const MeshGradientBackground({
    super.key,
    required this.baseColor,
    required this.colors,
    this.blurSigma = 50,
    this.duration = const Duration(seconds: 12),
    this.topScrimAlpha = 0.16,
  });

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(MeshGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            isComplex: true,
            willChange: true,
            painter: _MeshGradientPainter(
              animation: _controller,
              baseColor: widget.baseColor,
              colors: widget.colors,
              blurSigma: widget.blurSigma,
            ),
          ),
          if (widget.topScrimAlpha > 0)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: widget.topScrimAlpha),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// blob 하나의 궤도 정의. 좌표·반지름은 모두 카드 크기 대비 비율이다.
/// [freqX], [freqY] 는 애니메이션 한 주기에 대한 정수 배수여야 루프가 되감길 때 위치가 튀지 않는다.
class _BlobSpec {
  final double centerX;
  final double centerY;
  final double amplitudeX;
  final double amplitudeY;
  final int freqX;
  final int freqY;
  final double phaseX;
  final double phaseY;
  final double radius;
  final double opacity;

  /// 타원의 가로/세로 축 비율. 1이면 원, 커질수록 납작해진다.
  final double aspect;

  /// 타원의 회전 각도(라디안)
  final double angle;

  /// 시간에 따라 축 비율이 출렁이는 정도. 형태를 유기적으로 일그러뜨린다.
  final double wobble;

  const _BlobSpec({
    required this.centerX,
    required this.centerY,
    required this.amplitudeX,
    required this.amplitudeY,
    required this.freqX,
    required this.freqY,
    required this.phaseX,
    required this.phaseY,
    required this.radius,
    required this.opacity,
    required this.aspect,
    required this.angle,
    required this.wobble,
  });
}

/// 좌측 상단 모서리에서 카드 중심을 향해 타원형으로 늘어선 3개의 blob 궤도
/// [MeshGradientBackground.colors] 의 색상이 코너에서 가까운 순서대로 배정되며,
/// 코너에 가장 큰 blob 을 두고 중심 방향으로 갈수록 작아진다.
const _blobSpecs = <_BlobSpec>[
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

class _MeshGradientPainter extends CustomPainter {
  final Animation<double> animation;
  final Color baseColor;
  final List<Color> colors;
  final double blurSigma;

  _MeshGradientPainter({
    required this.animation,
    required this.baseColor,
    required this.colors,
    required this.blurSigma,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || colors.isEmpty) return;

    final bounds = Offset.zero & size;
    canvas.clipRect(bounds);
    canvas.drawRect(bounds, Paint()..color = baseColor);

    final t = animation.value;
    final shortestSide = size.shortestSide;
    final paint = Paint()
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    for (var i = 0; i < _blobSpecs.length; i++) {
      final spec = _blobSpecs[i];
      final center = Offset(
        size.width *
            (spec.centerX +
                spec.amplitudeX * cos(2 * pi * (spec.freqX * t + spec.phaseX))),
        size.height *
            (spec.centerY +
                spec.amplitudeY * sin(2 * pi * (spec.freqY * t + spec.phaseY))),
      );

      // freqX + freqY 가 정수라 루프가 되감겨도 형태가 이어진다.
      final wobble = spec.wobble *
          sin(2 * pi * ((spec.freqX + spec.freqY) * t + spec.phaseX));
      final radiusX = shortestSide * spec.radius * (spec.aspect + wobble);
      final radiusY = shortestSide * spec.radius * (1 / spec.aspect - wobble);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(spec.angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: radiusX * 2,
          height: radiusY * 2,
        ),
        paint
          ..color = colors[i % colors.length].withValues(
            alpha: spec.opacity,
          ),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_MeshGradientPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor ||
      oldDelegate.blurSigma != blurSigma ||
      !listEquals(oldDelegate.colors, colors);
}
