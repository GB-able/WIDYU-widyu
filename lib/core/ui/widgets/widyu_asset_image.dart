import 'package:flutter/widgets.dart';

/// [assets/images]에 저장된 이미지를 나타내기 위한 위젯
/// [name]에는 경로를 제외한 이미지의 파일 명만 전달하여 사용한다.
class WidyuAssetImage extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;

  /// 이미지 파일이 없거나 [name]이 비어있을 때 대신 그릴 위젯
  final Widget? fallback;

  const WidyuAssetImage({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.fit,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return _buildFallback();

    return Image.asset(
      'assets/images/$name',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return fallback ?? SizedBox(width: width, height: height);
  }
}
