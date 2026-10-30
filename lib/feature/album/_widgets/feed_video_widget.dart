import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class FeedVideoWidget extends StatefulWidget {
  const FeedVideoWidget({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.isActive,
  });

  final String url;
  final double width;
  final double height;
  final bool isActive;

  @override
  State<FeedVideoWidget> createState() => _FeedVideoWidgetState();
}

class _FeedVideoWidgetState extends State<FeedVideoWidget> {
  VideoPlayerController? _videoCtrl;
  bool _isMuted = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await controller.setLooping(true);

    try {
      await controller.initialize();
    } catch (_) {
      await controller.dispose();
      if (mounted) setState(() => _hasError = true);
      return;
    }

    if (!mounted) {
      await controller.dispose();
      return;
    }

    await controller.setVolume(_isMuted ? 0 : 1);
    setState(() => _videoCtrl = controller);
    if (widget.isActive) await controller.play();
  }

  @override
  void didUpdateWidget(covariant FeedVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.url != oldWidget.url) {
      _videoCtrl?.dispose();
      _videoCtrl = null;
      _hasError = false;
      _initController();
      return;
    }

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

  void _toggleMute(VideoPlayerController controller) {
    setState(() => _isMuted = !_isMuted);
    controller.setVolume(_isMuted ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _videoCtrl;

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: MyColor.grey100,
        alignment: Alignment.center,
        child: _hasError
            ? const Icon(Icons.videocam_off, color: MyColor.grey300, size: 48)
            : const CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller,
        builder: (context, value, _) => Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: value.size.width,
                  height: value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
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
                      child: WiduIcon(
                        icon: Assets.icons.ic18Play,
                        width: 18,
                        color: MyColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: GestureDetector(
                onTap: () => _toggleMute(controller),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: MyColor.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: MyColor.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
