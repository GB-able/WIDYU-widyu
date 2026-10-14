import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:widyu/app/routes/extra/photo_preview_extra.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

part 'widgets/image_preview.dart';
part 'widgets/video_preview.dart';

class PhotoPreviewScreen extends StatefulWidget {
  const PhotoPreviewScreen({super.key, required this.extra});

  final PhotoPreviewExtra extra;

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  late final PageController _pageCtrl = PageController(
    initialPage: widget.extra.initialIndex,
  );
  late int _currIdx = widget.extra.initialIndex;
  int _activePointers = 0;

  SelectPhotoViewModel get _viewModel => widget.extra.viewModel;

  void _onPointerDown(PointerDownEvent _) {
    setState(() => _activePointers++);
  }

  void _onPointerUp(PointerEvent _) {
    setState(() => _activePointers = (_activePointers - 1).clamp(0, 10));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onSelect(AssetEntity media) {
    if (_viewModel.toggleSelection(media)) context.pop();
  }

  void _onPageChanged(int index, int loadedCount) {
    setState(() => _currIdx = index);
    if (index >= loadedCount - 10) _viewModel.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final assets = _viewModel.currAssets;
        if (assets.isEmpty) return const Scaffold(appBar: CustomAppBar());

        final currIdx = _currIdx.clamp(0, assets.length - 1);
        final media = assets[currIdx];
        final isSelected = _viewModel.selectOrder(media) != null;
        final total = _viewModel.totalCount;

        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(title: "${currIdx + 1}/$total"),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: MyColor.white,
                    alignment: Alignment.center,
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      onPointerUp: _onPointerUp,
                      onPointerCancel: _onPointerUp,
                      child: PageView.builder(
                        controller: _pageCtrl,
                        physics: _activePointers >= 2
                            ? const NeverScrollableScrollPhysics()
                            : const PageScrollPhysics(),
                        itemCount: assets.length,
                        onPageChanged: (index) =>
                            _onPageChanged(index, assets.length),
                        itemBuilder: (context, index) {
                          final asset = assets[index];
                          return asset.type == AssetType.video
                              ? _VideoPreview(
                                  asset: asset,
                                  isActive: index == currIdx,
                                )
                              : _ImagePreview(asset: asset);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: WidyuTextButton(
                    onTap: () => _onSelect(media),
                    text: isSelected ? "선택 해제" : "선택",
                    enable: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
