part of '../photo_preview_screen.dart';

class _ImagePreview extends StatefulWidget {
  const _ImagePreview({required this.asset});

  final AssetEntity asset;

  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  final TransformationController _transformCtrl = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _transformCtrl.addListener(_onTransform);
  }

  void _onTransform() {
    final isZoomed = _transformCtrl.value.getMaxScaleOnAxis() > 1.01;
    if (isZoomed != _isZoomed) setState(() => _isZoomed = isZoomed);
  }

  @override
  void dispose() {
    _transformCtrl.removeListener(_onTransform);
    _transformCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformCtrl,
      panEnabled: _isZoomed,
      minScale: 1,
      maxScale: 4,
      child: SizedBox.expand(
        child: AssetEntityImage(
          widget.asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
