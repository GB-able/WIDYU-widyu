import 'dart:math' as math;

import 'package:flutter/material.dart';

class DashBorder extends CustomPainter {
  const DashBorder({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const _strokeWidth = 1.0;
  static const _dashLength = 4.0;
  static const _gapLength = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _strokeWidth / 2,
      _strokeWidth / 2,
      size.width - _strokeWidth,
      size.height - _strokeWidth,
    );
    if (rect.isEmpty) return;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(math.min(radius, rect.shortestSide / 2)),
        ),
      );
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      final dashCount = (metric.length / (_dashLength + _gapLength)).floor();
      if (dashCount == 0) continue;

      final step = metric.length / dashCount;
      final dash = step * _dashLength / (_dashLength + _gapLength);
      for (var i = 0; i < dashCount; i++) {
        canvas.drawPath(metric.extractPath(i * step, i * step + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(DashBorder oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
