import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:widyu/app/routes/extra/edit_post_extra.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/effects.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/album/manage_post/manage_post_view_model.dart';

part 'widgets/asset_video_preview.dart';
part 'widgets/media_carousel.dart';

enum ManageMode { add, edit }

class ManagePostScreen extends StatelessWidget {
  const ManagePostScreen.create({super.key, required this.photos})
      : type = ManageMode.add,
        extra = null;

  const ManagePostScreen.modify({super.key, required this.extra})
      : type = ManageMode.edit,
        photos = null;

  final ManageMode type;
  final List<AssetEntity>? photos;
  final EditPostExtra? extra;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ManagePostViewModel(
        repository: context.read<AlbumRepository>(),
        albumProvider: context.read<AlbumProvider>(),
        pointProvider: context.read<PointProvider>(),
        initialContent: extra == null
            ? null
            : context.read<AlbumProvider>().postOf(extra!.albumId)?.content ??
                extra!.content,
      ),
      child: Consumer<ManagePostViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: CustomAppBar(
            title: type == ManageMode.add ? '게시글 올리기' : '게시글 수정',
            actions: [
              GestureDetector(
                onTap: () {
                  if (type == ManageMode.edit) {
                    context.pop();
                    return;
                  }
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const IconWidget(icon: 'close', width: 24),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                _MediaCarousel(
                                  type: type,
                                  photos: photos,
                                  photoUrls: extra?.mediaUrls,
                                  currIdx: viewModel.currIdx,
                                  onPageChanged: viewModel.setCurrIdx,
                                ),
                                Expanded(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 240,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColor.white,
                                      boxShadow: [MyEffects.shadow],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: TextFormField(
                                      controller: viewModel.contentCtrl,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        hintText:
                                            '게시물에 대한 내용을 작성해주세요. (2,200자)',
                                        hintStyle: MyTypo.helper2.copyWith(
                                          color: MyColor.grey500,
                                        ),
                                        counterText: '',
                                      ),
                                      style: MyTypo.helper2,
                                      expands: true,
                                      maxLines: null,
                                      maxLength: 2200,
                                      textAlignVertical: TextAlignVertical.top,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    4,
                                    16,
                                    4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${viewModel.contentCtrl.text.length}/2,200자',
                                        style: MyTypo.helper.copyWith(
                                          color: MyColor.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: WidyuTextButton(
                    onTap: () async {
                      if (type == ManageMode.add) {
                        final success = await viewModel.uploadFeed(photos!);
                        if (success && context.mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                        return;
                      }

                      final content = await viewModel.updateFeed(
                        extra!.albumId,
                      );
                      if (content != null && context.mounted) {
                        context.pop();
                      }
                    },
                    text: type == ManageMode.add ? '게시글 올리기' : '수정 완료',
                    enable: !viewModel.isUploading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
