part of '../home_screen.dart';

/// 블러 처리된 색 덩어리(blob)들이 서로 다른 궤도로 떠다니는 mesh gradient 배경
/// [baseColor] 위에 [colors] 의 색상이 순서대로 blob 에 배정되며,
/// blob 개수가 색상 수보다 많으면 색상을 순환해서 사용한다.
/// 블러는 레이어 합성 비용이 큰 `BackdropFilter` 대신 [MaskFilter.blur] 로 처리한다.
class MeshGradientBackground extends StatefulWidget {
  /// blob 뒤에 깔리는 베이스 배경색
  final Color baseColor;

  /// blob에 사용할 색상 목록.
  /// blob 이 자체 색([_BlobSpec.color])을 지정하지 않은 경우에만 사용된다.
  final List<Color> colors;

  /// 그릴 blob 궤도 목록.
  /// 같은 part 파일들끼리만 쓰는 타입이라 private 타입 노출을 허용한다.
  // ignore: library_private_types_in_public_api
  final List<_BlobSpec> blobs;

  /// blob 경계를 뭉개는 블러 강도
  final double blurSigma;

  /// blob이 궤도를 한 바퀴 도는 데 걸리는 시간
  final Duration duration;

  /// 상단에 얹는 어두운 스크림의 투명도. 흰색 제목의 가독성을 위해 사용한다.
  final double topScrimAlpha;

  const MeshGradientBackground({
    super.key,
    required this.baseColor,
    this.colors = const [],
    required this.blobs,
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
              blobs: widget.blobs,
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

  /// blob 중심의 색. null 이면 [MeshGradientBackground.colors] 에서 순환 배정된 색을 사용한다.
  final Color? color;

  /// blob 가장자리의 색. 지정하면 [color] 에서 이 색으로 번지는 radial gradient 로 칠한다.
  /// null 이면 기존처럼 단색으로 칠하고 블러로 경계를 뭉갠다.
  final Color? edgeColor;

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
    this.color,
    this.edgeColor,
  });
}

class _MeshGradientPainter extends CustomPainter {
  final Animation<double> animation;
  final Color baseColor;
  final List<Color> colors;
  final List<_BlobSpec> blobs;
  final double blurSigma;

  _MeshGradientPainter({
    required this.animation,
    required this.baseColor,
    required this.colors,
    required this.blobs,
    required this.blurSigma,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || blobs.isEmpty) return;

    final bounds = Offset.zero & size;
    canvas.clipRect(bounds);
    canvas.drawRect(bounds, Paint()..color = baseColor);

    final t = animation.value;
    final shortestSide = size.shortestSide;
    final paint = Paint()
      ..isAntiAlias = true
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);

    for (var i = 0; i < blobs.length; i++) {
      final spec = blobs[i];
      final baseBlobColor =
          spec.color ?? (colors.isEmpty ? null : colors[i % colors.length]);
      if (baseBlobColor == null) continue;

      final center = Offset(
        size.width *
            (spec.centerX +
                spec.amplitudeX * cos(2 * pi * (spec.freqX * t + spec.phaseX))),
        size.height *
            (spec.centerY +
                spec.amplitudeY * sin(2 * pi * (spec.freqY * t + spec.phaseY))),
      );

      final wobble = spec.wobble *
          sin(2 * pi * ((spec.freqX + spec.freqY) * t + spec.phaseX));
      final radiusX = shortestSide * spec.radius * (spec.aspect + wobble);
      final radiusY = shortestSide * spec.radius * (1 / spec.aspect - wobble);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: radiusX * 2,
        height: radiusY * 2,
      );
      final edgeColor = spec.edgeColor;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(spec.angle);
      canvas.drawOval(
        rect,
        edgeColor == null
            ? (paint..color = baseBlobColor.withValues(alpha: spec.opacity))
            : (Paint()
              ..isAntiAlias = true
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma)
              ..shader = RadialGradient(
                colors: [
                  baseBlobColor.withValues(alpha: spec.opacity),
                  edgeColor.withValues(alpha: spec.opacity),
                ],
              ).createShader(rect)),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_MeshGradientPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor ||
      oldDelegate.blurSigma != blurSigma ||
      !listEquals(oldDelegate.colors, colors) ||
      !listEquals(oldDelegate.blobs, blobs);
}
