import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/extensions/int_extension.dart';
import 'package:widyu/feature/album/_widgets/album_empty_widget.dart';
import 'package:widyu/feature/album/_widgets/lock_overlay.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';
import 'package:widyu/feature/album/photo/photo_tab_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/media_thumbnail.dart';
part 'widgets/month_title.dart';

class _MonthSection {
  _MonthSection(this.month) : media = [];

  final String month;
  final List<Media> media;
}

List<_MonthSection> _groupByMonth(List<Media> items) {
  final sections = <_MonthSection>[];

  for (final media in items) {
    final createdAt = DateTime.parse(media.createdAt);
    final month = '${createdAt.year}년 ${createdAt.month}월';

    if (sections.isEmpty || sections.last.month != month) {
      sections.add(_MonthSection(month));
    }
    sections.last.media.add(media);
  }

  return sections;
}

class PhotoTabView extends StatelessWidget {
  const PhotoTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhotoTabViewModel(
        repository: context.read<AlbumRepository>(),
      )..init(),
      child: const _PhotoGrid(),
    );
  }
}

class _PhotoGrid extends StatefulWidget {
  const _PhotoGrid();

  @override
  State<_PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<_PhotoGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<PhotoTabViewModel>().loadMore();
    }
  }

  // 사진 탭은 게시물 캐시가 없을 수 있어 미디어의 가격을 쓴다.
  Future<bool> _requestUnlock(Media media) async {
    final repository = context.read<AlbumRepository>();
    final success = await showUnlockDialog(
      context,
      price: media.price,
      point: context.read<PointRepository>().currentStatus.point,
      isUnlocking: repository.currentCache.isUnlocking(media.postId),
      onPurchase: () => repository.unlock(media.postId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PhotoTabViewModel>();
    final cache = viewModel.cache;

    if (viewModel.isLoading) {
      return const CustomLoadingWidget();
    }

    if (viewModel.isEmpty) {
      if (viewModel.hasError) {
        return CustomErrorWidget(
          errorMsg: '앨범을 불러오지 못했어요',
          onRetry: () => context.read<PhotoTabViewModel>().retry(),
        );
      }
      return const AlbumEmptyWidget();
    }

    final sections = _groupByMonth(viewModel.items);

    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: MyColor.white,
      onRefresh: () => context.read<PhotoTabViewModel>().init(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverMainAxisGroup(
              slivers: [
                for (final section in sections) ...[
                  SliverToBoxAdapter(child: _MonthTitle(month: section.month)),
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 3 / 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final media = section.media[index];
                        return _MediaThumbnail(
                          media: media,
                          isLocked: !cache.isUnlocked(media.postId),
                          onRequestUnlock: () => _requestUnlock(media),
                        );
                      },
                      childCount: section.media.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
                if (viewModel.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (viewModel.hasError)
                  SliverToBoxAdapter(
                    child: RetryWidget(
                      onRetry: () => context.read<PhotoTabViewModel>().retry(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
