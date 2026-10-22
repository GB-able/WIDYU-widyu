part of '../manage_post_screen.dart';

class _AssetVideoPreview extends StatefulWidget {
  const _AssetVideoPreview({
    required this.asset,
    required this.isActive,
    required this.width,
    required this.height,
  });

  final AssetEntity asset;
  final bool isActive;
  final double width;
  final double height;

  @override
  State<_AssetVideoPreview> createState() => _AssetVideoPreviewState();
}

class _AssetVideoPreviewState extends State<_AssetVideoPreview> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final file = await widget.asset.file;
    if (file == null || !mounted) return;

    final controller = VideoPlayerController.file(file);
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.initialize();

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() => _controller = controller);
    if (widget.isActive) await controller.play();
  }

  @override
  void didUpdateWidget(covariant _AssetVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _controller?.play() : _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: controller == null || !controller.value.isInitialized
          ? AssetEntityImage(widget.asset, fit: BoxFit.cover)
          : ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
    );
  }
}
