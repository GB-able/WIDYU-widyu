import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';
import 'package:widyu/feature/album/_widgets/album_empty_widget.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';
import 'package:widyu/feature/album/feed/feed_tab_view_model.dart';

part 'widgets/feed_list.dart';

class FeedTabView extends StatelessWidget {
  const FeedTabView({super.key});

  @override
  Widget build(BuildContext context) => const _FeedList();
}
