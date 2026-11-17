import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:widyu/gen/assets.gen.dart';

class WiduIcon extends StatelessWidget {
  final SvgGenImage icon;
  final double? width;
  final double? height;
  final Color? color;

  const WiduIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    // colorFilter로 색을 입히면 아이콘마다 saveLayer(별도 렌더 패스)가 생긴다.
    // SVG를 읽을 때 색을 바꿔 두면 saveLayer 없이 벡터 그대로 그린다.
    return icon.svg(
      width: width,
      height: height,
      colorMapper: color == null ? null : _Tint(color),
    );
  }
}

/// SVG의 모든 색을 [color]로 바꾼다. 원래 투명도는 곱해서 남기므로
/// 불투명한 [color]면 `BlendMode.srcIn` 색 필터와 결과가 같다.
/// 색 속성이 없는 도형(기본 검정)은 바뀌지 않고 mask 안의 색은 바뀌는데, 지금 아이콘에는 둘 다 없다.
/// 로더 캐시 키에 들어가므로 같은 색이면 같다고 비교되어야 다시 파싱하지 않는다.
class _Tint extends ColorMapper {
  const _Tint(this.color);

  final Color color;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) =>
      this.color.withValues(alpha: this.color.a * color.a);

  @override
  bool operator ==(Object other) => other is _Tint && other.color == color;

  @override
  int get hashCode => color.hashCode;
}
