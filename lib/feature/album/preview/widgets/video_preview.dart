part of '../photo_preview_screen.dart';

class _VideoPreview extends StatefulWidget {
  const _VideoPreview({required this.asset, required this.isActive});

  final AssetEntity asset;
  final bool isActive;

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  VideoPlayerController? _videoCtrl;

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
    await controller.initialize();

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() => _videoCtrl = controller);
    if (widget.isActive) await controller.play();
  }

  @override
  void didUpdateWidget(covariant _VideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _videoCtrl?.play() : _videoCtrl?.pause();
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  void _togglePlay(VideoPlayerController controller) {
    controller.value.isPlaying ? controller.pause() : controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _videoCtrl;

    if (controller == null || !controller.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AssetEntityImage(widget.asset, fit: BoxFit.contain),
          const CircularProgressIndicator(),
        ],
      );
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) => Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _togglePlay(controller),
              child: Center(
                child: AnimatedOpacity(
                  opacity: value.isPlaying ? 0 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColor.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const IconWidget(
                      icon: 'play',
                      width: 18,
                      color: MyColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
