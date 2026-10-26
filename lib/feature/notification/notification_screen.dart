import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/notification/notification_category.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_view_model.dart';

part 'widgets/notification_empty_widget.dart';
part 'widgets/notification_filter_bar.dart';
part 'widgets/notification_list.dart';
part 'widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationViewModel(
        repository: context.read<NotificationRepository>(),
      ),
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: const CustomAppBar(title: '알림'),
        body: Column(
          children: [
            const _NotificationFilterBar(),
            Expanded(
              child: Builder(
                builder: (context) {
                  final viewModel = context.watch<NotificationViewModel>();

                  if (viewModel.isLoading) {
                    return const CustomLoadingWidget();
                  }

                  if (viewModel.isEmpty) {
                    if (viewModel.hasError) {
                      return CustomErrorWidget(
                        errorMsg: '알림을 불러오지 못했어요.\n잠시 후 다시 시도해 주세요.',
                        onRetry: () =>
                            context.read<NotificationViewModel>().retry(),
                      );
                    }
                    return const _NotificationEmptyWidget();
                  }

                  return const _NotificationList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
