import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

part 'widgets/image_preview.dart';
part 'widgets/video_preview.dart';

class PhotoPreviewScreen extends StatefulWidget {
  const PhotoPreviewScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  late final PageController _pageCtrl = PageController(
    initialPage: widget.initialIndex,
  );
  late int _currIdx = widget.initialIndex;
  int _activePointers = 0;

  late final SelectPhotoViewModel _viewModel =
      context.read<SelectPhotoViewModel>();

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

  void _onWritePost() {
    context.push(AppRoute.managePost.path, extra: _viewModel.selected);
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
        final total = _viewModel.totalCount;
        final order = _viewModel.selectOrder(media);

        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: CustomAppBar(
            title: "${currIdx + 1}/$total",
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
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
                      Positioned(
                        top: 4,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => _viewModel.toggleSelection(media),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 320, sigmaY: 320),
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: order != null
                                      ? MyColor.primary
                                      : const Color(0x6616161D),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: MyColor.white,
                                    width: 2,
                                  ),
                                ),
                                child: order != null
                                    ? Text(
                                        order.toString(),
                                        style: MyTypo.title1.copyWith(
                                          color: MyColor.white,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: WidyuTextButton(
                    onTap: _onWritePost,
                    text: "게시글 작성하기",
                    enable: _viewModel.selected.isNotEmpty,
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
