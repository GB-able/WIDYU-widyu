part of '../home_screen.dart';

class _WalkingCard extends StatelessWidget {
  final double stepProgress;

  const _WalkingCard({required this.stepProgress});

  @override
  Widget build(BuildContext context) {
    return _CarouselCardShell(
      title: '걷기',
      background: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MyColor.primary900,
                  MyColor.primary200,
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 20),
            child: const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MyColor.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Transform.translate(
        offset: const Offset(0, 20),
        child: Center(
          child: SizedBox(
            width: 180,
            height: 180,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: stepProgress),
              duration: const Duration(milliseconds: 800), // 애니메이션 시간
              curve: Curves.easeOutCubic,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: ColoredBox(
                  color: MyColor.white.withValues(alpha: 0.3),
                ),
              ),
              builder: (context, animatedProgress, child) => CustomPaint(
                painter: _StepProgressTickPainter(progress: animatedProgress),
                foregroundPainter: _StepProgressPieBorderPainter(
                  progress: animatedProgress,
                ),
                child: ClipPath(
                  clipper: _StepProgressPieClipper(progress: animatedProgress),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Path _buildStepProgressPiePath(double progress, Size size) {
  final clamped = (progress / 100).clamp(0.0, 1.0);
  final path = Path();
  if (clamped <= 0) return path;

  final center = Offset(size.width / 2, size.height / 2);
  final radius = size.shortestSide / 2;
  final rect = Rect.fromCircle(center: center, radius: radius);

  if (clamped >= 1) return path..addOval(rect);

  final startAngle = -pi / 2 + (1 - clamped) * 2 * pi;
  final sweepAngle = clamped * 2 * pi;

  return path
    ..moveTo(center.dx, center.dy)
    ..arcTo(rect, startAngle, sweepAngle, false)
    ..close();
}

class _StepProgressPieClipper extends CustomClipper<Path> {
  final double progress;

  const _StepProgressPieClipper({required this.progress});

  @override
  Path getClip(Size size) => _buildStepProgressPiePath(progress, size);

  @override
  bool shouldReclip(_StepProgressPieClipper oldClipper) =>
      oldClipper.progress != progress;
}

class _StepProgressTickPainter extends CustomPainter {
  final double progress;

  const _StepProgressTickPainter({required this.progress});

  static const _tickCount = 24; // 눈금 개수

  @override
  void paint(Canvas canvas, Size size) {
    final clamped = (progress / 100).clamp(0.0, 1.0);
    final removedSweep = (1 - clamped) * 2 * pi;
    if (removedSweep <= 0) return;

    final paint = Paint()
      ..color = MyColor.grey600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 // 진행률 눈금 두께
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide / 2;
    final innerRadius = outerRadius - 16.0; // 진행률 눈금 길이
    const tickStep = 2 * pi / _tickCount;

    for (var i = 0; i < _tickCount; i++) {
      final angleFromTop = i * tickStep;
      if (angleFromTop >= removedSweep) break;

      final angle = -pi / 2 + angleFromTop;
      final direction = Offset(cos(angle), sin(angle));
      canvas.drawLine(
        center + direction * outerRadius,
        center + direction * innerRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StepProgressTickPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StepProgressPieBorderPainter extends CustomPainter {
  final double progress;

  const _StepProgressPieBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColor.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..isAntiAlias = true;

    canvas.drawPath(_buildStepProgressPiePath(progress, size), paint);
  }

  @override
  bool shouldRepaint(_StepProgressPieBorderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
