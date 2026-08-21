part of '../home_screen.dart';

/// 경계가 뭉개진 색 덩어리(blob)들이 서로 다른 궤도로 떠다니는 mesh gradient 배경
/// [baseColor] 위에 [colors] 의 색상이 순서대로 blob 에 배정되며,
/// blob 개수가 색상 수보다 많으면 색상을 순환해서 사용한다.
///
/// 경계의 뭉개짐은 오프스크린 렌더가 필요한 블러(`BackdropFilter`·`MaskFilter.blur`)
/// 대신, 가우시안 감쇠를 근사한 radial gradient 의 알파 페이드로 표현한다.
/// blob 하나당 셰이더는 한 번만 만들고 위치·크기 변화는 캔버스 변환으로 처리하므로
/// 프레임당 비용이 draw call 몇 개 수준으로 유지된다.
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

  /// blob 경계가 뭉개지는 정도. 가우시안 블러의 시그마와 같은 의미로,
  /// 경계는 이 값의 [_MeshGradientPainter._fadeSigmaSpan] 배만큼 번진다.
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
  /// 배경을 다시 그리는 빈도.
  /// blob 은 한 주기(기본 12초) 동안 카드 크기의 4~10% 만 움직이므로
  /// 디스플레이 주사율(60~120Hz)로 다시 그릴 이유가 없다.
  static const _repaintFps = 12;

  /// 양자화된 애니메이션 진행도. 이 값이 바뀔 때만 페인터가 다시 그린다.
  final ValueNotifier<double> _progress = ValueNotifier(0);

  late final AnimationController _controller;

  late _MeshGradientPainter _painter = _createPainter();

  @override
  void initState() {
    super.initState();
    // 반드시 여기서 만들어야 한다. 지연 초기화로 두면 build() 가 [_progress] 만 참조하는 탓에
    // dispose() 의 `_controller.dispose()` 가 최초 접근이 되고, 그 시점에 Ticker 가 생성되면서
    // 이미 비활성화된 element 에서 TickerMode 를 조회해 예외가 난다.
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(_onTick)
      ..repeat();
  }

  /// 한 주기를 나누는 단계 수. 단계가 바뀔 때만 리페인트가 발생한다.
  int get _steps =>
      max(1, (widget.duration.inMilliseconds * _repaintFps / 1000).round());

  void _onTick() {
    final quantized = (_controller.value * _steps).floor() / _steps;
    if (quantized != _progress.value) _progress.value = quantized;
  }

  _MeshGradientPainter _createPainter() => _MeshGradientPainter(
        progress: _progress,
        baseColor: widget.baseColor,
        colors: widget.colors,
        blobs: widget.blobs,
        blurSigma: widget.blurSigma,
      );

  @override
  void didUpdateWidget(MeshGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
    // 페인터는 입력이 바뀔 때만 새로 만든다. 캐시해 둔 셰이더를 매 리빌드마다
    // 버리지 않기 위한 것으로, 애니메이션에 의한 리페인트는 [_progress] 가 담당한다.
    if (oldWidget.baseColor != widget.baseColor ||
        oldWidget.blurSigma != widget.blurSigma ||
        !listEquals(oldWidget.colors, widget.colors) ||
        !listEquals(oldWidget.blobs, widget.blobs)) {
      _painter = _createPainter();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(willChange: true, painter: _painter),
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
  /// null 이면 [color] 단색이 그대로 경계까지 이어지며 알파만 감쇠한다.
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
  final ValueNotifier<double> progress;
  final Color baseColor;
  final List<Color> colors;
  final List<_BlobSpec> blobs;
  final double blurSigma;

  /// blob 별 radial gradient 셰이더 캐시.
  /// 색과 stop 은 시간에 무관하므로 크기가 바뀔 때만 다시 만든다.
  final List<Shader?> _shaders;

  /// 셰이더를 만들 때 기준으로 삼은 카드의 짧은 변. 값이 바뀌면 캐시를 버린다.
  double _shaderShortestSide = 0;

  _MeshGradientPainter({
    required this.progress,
    required this.baseColor,
    required this.colors,
    required this.blobs,
    required this.blurSigma,
  })  : _shaders = List<Shader?>.filled(blobs.length, null),
        super(repaint: progress);

  /// 경계 페이드가 덮는 범위(± 시그마 배수). 가우시안은 3σ 밖에서 사실상 0 이다.
  static const _fadeSigmaSpan = 3.0;

  /// 반지름 1인 단위 타원. 실제 크기는 캔버스 스케일로 맞춘다.
  static const _unitOval = Rect.fromLTRB(-1, -1, 1, 1);

  /// 가우시안 누적분포를 [-3σ, +3σ] 구간에서 균등 분할해 뽑은 알파 표.
  /// 하드한 경계에 블러를 먹였을 때의 감쇠를 그라디언트 stop 으로 근사한다.
  static const _falloff = <double>[
    0.9987,
    0.9878,
    0.9332,
    0.7734,
    0.5,
    0.2266,
    0.0668,
    0.0122,
    0.0,
  ];

  double get _fadeWidth => blurSigma * _fadeSigmaSpan;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || blobs.isEmpty) return;

    final bounds = Offset.zero & size;
    canvas.clipRect(bounds);
    canvas.drawRect(bounds, Paint()..color = baseColor);

    final shortestSide = size.shortestSide;
    if (_shaderShortestSide != shortestSide) {
      _shaderShortestSide = shortestSide;
      _shaders.fillRange(0, _shaders.length, null);
    }

    final t = progress.value;
    final paint = Paint()..isAntiAlias = true;

    for (var i = 0; i < blobs.length; i++) {
      final spec = blobs[i];
      final shader = _shaderFor(i, shortestSide);
      if (shader == null) continue;

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

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(spec.angle);
      // 페이드가 번지는 폭만큼 반지름을 키워, 블러를 먹였을 때의 실제 범위를 재현한다.
      canvas.scale(radiusX + _fadeWidth, radiusY + _fadeWidth);
      canvas.drawOval(_unitOval, paint..shader = shader);
      canvas.restore();
    }
  }

  Shader? _shaderFor(int index, double shortestSide) {
    final cached = _shaders[index];
    if (cached != null) return cached;

    final spec = blobs[index];
    final core = spec.color ??
        (colors.isEmpty ? null : colors[index % colors.length]);
    if (core == null) return null;

    final shader = _buildBlobGradient(spec, core, shortestSide)
        .createShader(_unitOval);
    _shaders[index] = shader;
    return shader;
  }

  /// [_unitOval] 기준으로 그릴 blob 의 그라디언트를 만든다.
  /// 색은 중심의 [core] 에서 [_BlobSpec.edgeColor] 로 번지고,
  /// 알파는 blob 반지름을 중심으로 ±[_fadeWidth] 구간에서 가우시안처럼 감쇠한다.
  RadialGradient _buildBlobGradient(
    _BlobSpec spec,
    Color core,
    double shortestSide,
  ) {
    final edge = spec.edgeColor ?? core;

    // 두 축 반지름의 기하평균. aspect 를 곱하고 나누는 구조라 결과적으로 이 값과 같다.
    final radius = shortestSide * spec.radius;
    final outer = radius + _fadeWidth;
    final inner = max(0.0, radius - _fadeWidth);

    final stops = <double>[0];
    final stopColors = <Color>[core.withValues(alpha: spec.opacity)];

    for (var i = 0; i < _falloff.length; i++) {
      final band = i / (_falloff.length - 1);
      final r = inner + (outer - inner) * band;
      stops.add(r / outer);
      stopColors.add(
        Color.lerp(core, edge, (r / radius).clamp(0.0, 1.0))!
            .withValues(alpha: spec.opacity * _falloff[i]),
      );
    }

    return RadialGradient(colors: stopColors, stops: stops);
  }

  @override
  bool shouldRepaint(_MeshGradientPainter oldDelegate) =>
      oldDelegate.baseColor != baseColor ||
      oldDelegate.blurSigma != blurSigma ||
      !listEquals(oldDelegate.colors, colors) ||
      !listEquals(oldDelegate.blobs, blobs);
}
