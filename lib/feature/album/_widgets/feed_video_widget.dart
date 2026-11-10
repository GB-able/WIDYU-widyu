import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class FeedVideoWidget extends StatefulWidget {
  const FeedVideoWidget({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.isActive,
    this.thumbnailUrl,
  });

  final String url;
  final double width;
  final double height;
  final bool isActive;
  final String? thumbnailUrl;

  @override
  State<FeedVideoWidget> createState() => _FeedVideoWidgetState();
}

class _FeedVideoWidgetState extends State<FeedVideoWidget> {
  VideoPlayerController? _videoCtrl;
  bool _isMuted = true;
  bool _hasError = false;
  bool _revealed = false;
  ScrollableState? _scrollable;
  bool _isVisible = false;
  bool _tickerEnabled = true;

  bool get _shouldPlay => widget.isActive && _isVisible && _tickerEnabled;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tickerEnabled = TickerMode.of(context);
    final scrollable = Scrollable.maybeOf(context, axis: Axis.vertical);
    if (scrollable != _scrollable) {
      _scrollable?.position.removeListener(_updateVisibility);
      _scrollable = scrollable;
      scrollable?.position.addListener(_updateVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
    _syncPlayback();
  }

  void _updateVisibility() {
    if (!mounted) return;
    final visible = _visibleFraction() >= 0.5;
    if (visible == _isVisible) return;
    _isVisible = visible;
    _syncPlayback();
  }

  double _visibleFraction() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return 0;
    final scrollable = _scrollable;
    if (scrollable == null) return 1;
    final viewport = scrollable.context.findRenderObject();
    if (viewport is! RenderBox || !viewport.hasSize) return 0;
    final height = box.size.height;
    if (height <= 0) return 0;
    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final shown =
        math.min(top + height, viewport.size.height) - math.max(top, 0.0);
    return (shown / height).clamp(0.0, 1.0);
  }

  void _syncPlayback() {
    final controller = _videoCtrl;
    if (controller == null || !controller.value.isInitialized) return;
    _shouldPlay ? controller.play() : controller.pause();
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
    controller.addListener(_revealOnFirstFrame);
    setState(() => _videoCtrl = controller);
    _syncPlayback();
  }

  @override
  void didUpdateWidget(covariant FeedVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.url != oldWidget.url) {
      _videoCtrl?.dispose();
      _videoCtrl = null;
      _hasError = false;
      _revealed = false;
      _initController();
      return;
    }

    if (widget.isActive != oldWidget.isActive) _syncPlayback();
  }

  @override
  void dispose() {
    _scrollable?.position.removeListener(_updateVisibility);
    _videoCtrl?.dispose();
    super.dispose();
  }

  void _revealOnFirstFrame() {
    final controller = _videoCtrl;
    if (_revealed || controller == null) return;
    if (controller.value.position <= Duration.zero) return;
    controller.removeListener(_revealOnFirstFrame);
    setState(() => _revealed = true);
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
    final isReady = controller != null && controller.value.isInitialized;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _background(isReady),
          if (!isReady && !_hasError) Center(child: _playIcon()),
          if (isReady) ...[
            AnimatedOpacity(
              opacity: _revealed ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (context, value, _) => Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _togglePlay(controller),
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: value.isPlaying ? 0 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: _playIcon(),
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
          ],
        ],
      ),
    );
  }

  Widget _playIcon() => Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColor.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: WiduIcon(
            icon: Assets.icons.ic18Play, width: 18, color: MyColor.white),
      );

  Widget _background(bool isReady) {
    final thumbnailUrl = widget.thumbnailUrl;
    if (!_hasError && thumbnailUrl != null) {
      return CustomNetworkImage(
        url: thumbnailUrl,
        width: widget.width,
        height: widget.height,
      );
    }
    return Container(
      color: MyColor.grey100,
      alignment: Alignment.center,
      child: _hasError
          ? const Icon(Icons.videocam_off, color: MyColor.grey300, size: 48)
          : isReady
              ? null
              : const CircularProgressIndicator(),
    );
  }
}
