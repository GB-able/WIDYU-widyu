import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/extensions/int_extension.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/permission_denied_widget.dart';
part 'widgets/photo_grid.dart';
part 'widgets/photo_header.dart';
part 'widgets/photo_item.dart';

class SelectPhotoScreen extends ConsumerWidget {
  const SelectPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(selectPhotoViewModelProvider.notifier);
    final uiState = ref.watch(selectPhotoViewModelProvider);

    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: _PhotoHeader(
        filter: uiState.filter,
        setFilter: viewModel.setFilter,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: uiState.photoPermission == null
                  ? const CustomLoadingWidget()
                  : uiState.hasPhotoPermission
                      ? _PhotoGrid(
                          assets: uiState.currAssets,
                          isLoading: uiState.isLoading,
                          isCapturing: uiState.isCapturing,
                          cameraPermission: uiState.cameraPermission,
                          selectOrder: uiState.selectOrder,
                          onLoadMore: viewModel.loadMore,
                          onCapture: viewModel.captureFromCamera,
                          onToggle: viewModel.toggleSelection,
                        )
                      : const _PermissionDeniedWidget(),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child:
                  uiState.photoPermission == null || uiState.hasPhotoPermission
                      ? WidyuTextButton(
                          onTap: () => context.push(
                            AppRoute.managePost.path,
                            extra: uiState.selected,
                          ),
                          text: '게시글 작성하기',
                          enable: uiState.selected.isNotEmpty,
                        )
                      : Column(
                          spacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  '나중에 하기',
                                  style: MyTypo.button.copyWith(
                                    color: MyColor.grey600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            WidyuTextButton(
                              onTap: () => viewModel.requestAlbumPermission(),
                              text: '설정에서 권한 허용하기',
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
