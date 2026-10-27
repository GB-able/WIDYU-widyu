import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/feature/album/_widgets/album_empty_widget.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/feed/feed_tab_view_model.dart';

part 'widgets/feed_list.dart';

class FeedTabView extends StatelessWidget {
  const FeedTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedTabViewModel(
        repository: context.read<AlbumRepository>(),
        albumProvider: context.read<AlbumProvider>(),
      )..init(),
      child: const _FeedList(),
    );
  }
}
