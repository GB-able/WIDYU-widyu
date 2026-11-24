import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/ui/theme/colors.dart';

/// 스켈레톤 블록이 흐려졌다 진해지기를 반복하되, 왼쪽부터 늦게 시작해
/// 페이드가 왼쪽에서 오른쪽으로 물결처럼 지나가는 효과.
///
/// [Skeletonizer]는 영역 전체에 셰이더 하나를 쓰므로, 가로 위치마다
/// 그 시점의 색을 계산한 그라데이션으로 블록별 지연을 흉내 낸다.
class WavePulseEffect extends PaintingEffect {
  const WavePulseEffect({
    this.color = MyColor.grey200,
    this.background = MyColor.grey50,
  }) : super(duration: _cycle);

  /// 가장 진할 때의 블록 색.
  final Color color;

  /// 가장 흐릴 때의 색. 카드 배경과 같게 해서 카드 안 블록이 카드보다 밝아지지 않게 한다.
  final Color background;

  // 한쪽 방향 0.9초, 왕복 1.8초. 왼쪽 끝에서 오른쪽 끝까지 0.7초 늦어진다.
  static const _half = 0.9;
  static const _cycle = Duration(milliseconds: 1800);
  static const _wave = 0.7;
  static const _minOpacity = 0.15;
  static const _stops = 16;

  Color _colorAt(double seconds) {
    var phase = (seconds / _half) % 2;
    if (phase < 0) phase += 2;
    final fade = Curves.easeInOut.transform(phase <= 1 ? phase : 2 - phase);
    final opacity = 1 - (1 - _minOpacity) * fade;
    return Color.lerp(background, color, opacity)!;
  }

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    final now = t * _cycle.inMilliseconds / 1000;
    final stops = [for (var i = 0; i <= _stops; i++) i / _stops];
    return Paint()
      ..shader = LinearGradient(
        colors: [for (final x in stops) _colorAt(now - x * _wave)],
        stops: stops,
      ).createShader(rect);
  }

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) => other ?? this;

  @override
  bool operator ==(Object other) =>
      other is WavePulseEffect &&
      other.color == color &&
      other.background == background;

  @override
  int get hashCode => Object.hash(color, background);
}
