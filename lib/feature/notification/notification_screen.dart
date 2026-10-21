import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
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
      create: (_) => NotificationViewModel(),
      child: const Scaffold(
        backgroundColor: MyColor.white,
        appBar: CustomAppBar(title: "알림"),
        body: Column(
          children: [
            _NotificationFilterBar(),
            Expanded(child: _NotificationList()),
          ],
        ),
      ),
    );
  }
}
