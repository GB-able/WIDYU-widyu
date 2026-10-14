part of '../medication_camera_screen.dart';

/// 카메라 프리뷰와 가이드, 셔터를 보여준다.
/// [CameraController] 는 렌더링 계층에 결합되어 있으므로 이 위젯이 소유한다.
class _CameraCaptureView extends StatefulWidget {
  final int? doseCount;
  final ValueChanged<String> onCaptured;
  final VoidCallback onFailure;

  const _CameraCaptureView({
    required this.doseCount,
    required this.onCaptured,
    required this.onFailure,
  });

  @override
  State<_CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<_CameraCaptureView>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitializing = false;

  // 촬영 직후 화면이 닫히는 동안 다시 눌러 pop 이 두 번 되는 것을 막는다.
  bool _hasCaptured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  /// 백그라운드에서는 카메라를 놓아줘야 하므로 비활성화 시 해제하고 복귀 시 다시 연다.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (state == AppLifecycleState.inactive && controller != null) {
      setState(() => _controller = null);
      controller.dispose();
    } else if (state == AppLifecycleState.resumed && controller == null) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (it) => it.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        // 업로드 용량을 고려해 high(720p)로 촬영한다.
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) widget.onFailure();
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        controller.value.isTakingPicture ||
        _hasCaptured) {
      return;
    }
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      _hasCaptured = true;
      widget.onCaptured(file.path);
    } catch (_) {
      if (mounted) widget.onFailure();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final doseCount = widget.doseCount;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (controller == null)
          const Center(child: CircularProgressIndicator())
        else
          _FullScreenPreview(controller: controller),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.white,
                    borderRadius: BorderRadius.circular(10000),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: doseCount == null
                          ? const [TextSpan(text: '복용하신 약을 촬영해주세요')]
                          : [
                              const TextSpan(text: '복용하신 약 '),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Text(
                                  '$doseCount정',
                                  style: MyTypo.title1.copyWith(
                                    color: MyColor.primary,
                                  ),
                                ),
                              ),
                              const TextSpan(text: '을 촬영해 주세요.'),
                            ],
                    ),
                    textAlign: TextAlign.center,
                    style: MyTypo.title3.copyWith(
                      color: MyColor.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CustomPaint(painter: _CaptureGuidePainter()),
              ),
            ),
            const SizedBox(height: 16),
            // 하단 버튼 영역. 내비게이션 바 뒤까지 반투명 배경을 채운다.
            ColoredBox(
              color: _scrimColor,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 16),
                  child: Center(
                    child: Semantics(
                      button: true,
                      label: '촬영',
                      child: GestureDetector(
                        onTap: controller == null ? null : _takePicture,
                        child: Container(
                          width: 68,
                          height: 68,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: MyColor.orange300, width: 2),
                          ),
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColor.orange300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FullScreenPreview extends StatelessWidget {
  final CameraController controller;

  const _FullScreenPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = controller.value.previewSize!;

    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: size.height,
          height: size.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _CaptureGuidePainter extends CustomPainter {
  const _CaptureGuidePainter();

  static const _length = 32.0;
  static const _strokeWidth = 3.0;
  static const _radius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MyColor.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    final rect = (Offset.zero & size).deflate(_strokeWidth / 2);

    final corner = Path()
      ..moveTo(0, _length)
      ..lineTo(0, _radius)
      ..arcToPoint(
        const Offset(_radius, 0),
        radius: const Radius.circular(_radius),
      )
      ..lineTo(_length, 0);

    for (final (origin, scaleX, scaleY) in [
      (rect.topLeft, 1.0, 1.0),
      (rect.topRight, -1.0, 1.0),
      (rect.bottomLeft, 1.0, -1.0),
      (rect.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..save()
        ..translate(origin.dx, origin.dy)
        ..scale(scaleX, scaleY)
        ..drawPath(corner, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_CaptureGuidePainter oldDelegate) => false;
}
