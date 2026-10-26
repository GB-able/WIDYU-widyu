import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/extensions/int_extension.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

part 'widgets/permission_denied_widget.dart';
part 'widgets/photo_grid.dart';
part "widgets/photo_header.dart";
part 'widgets/photo_item.dart';

class SelectPhotoScreen extends StatelessWidget {
  const SelectPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectPhotoViewModel>(
      builder: (context, viewModel, _) => Scaffold(
        backgroundColor: MyColor.white,
        appBar: _PhotoHeader(
          filter: viewModel.filter,
          setFilter: viewModel.setFilter,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: viewModel.photoPermission == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : viewModel.hasPhotoPermission
                        ? const _PhotoGrid()
                        : _PermissionDeniedWidget(viewModel: viewModel),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: viewModel.photoPermission == null ||
                        viewModel.hasPhotoPermission
                    ? WidyuTextButton(
                        onTap: () => context.push(
                          AppRoute.managePost.path,
                          extra: viewModel.selected,
                        ),
                        text: "게시글 작성하기",
                        enable: viewModel.selected.isNotEmpty,
                      )
                    : Column(
                        spacing: 10,
                        children: [
                          WidyuTextButton(
                            onTap: () => viewModel.requestAlbumPermission(),
                            text: "설정에서 권한 허용하기",
                            enable: true,
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "나중에 하기",
                                style: MyTypo.button.copyWith(
                                  color: MyColor.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
  }
}
