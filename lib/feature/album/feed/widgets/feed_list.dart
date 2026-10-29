part of '../feed_tab_view.dart';

class _FeedList extends StatefulWidget {
  const _FeedList();

  @override
  State<_FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<_FeedList> {
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
      context.read<FeedTabViewModel>().loadMore();
    }
  }

  // 탭 시점의 캐시와 포인트로 판단한다.
  Future<bool> _requestUnlock(int albumId) async {
    final repository = context.read<AlbumRepository>();
    final cache = repository.currentCache;
    final success = await showUnlockDialog(
      context,
      price: cache.postOf(albumId)?.price,
      point: context.read<PointRepository>().currentStatus.point,
      isUnlocking: cache.isUnlocking(albumId),
      onPurchase: () => repository.unlock(albumId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FeedTabViewModel>();
    final cache = viewModel.cache;

    if (viewModel.isLoading) {
      return const CustomLoadingWidget();
    }

    if (viewModel.isEmpty) {
      if (viewModel.hasError) {
        return CustomErrorWidget(
          errorMsg: '피드를 불러오지 못했어요',
          onRetry: () => context.read<FeedTabViewModel>().retry(),
        );
      }
      return const AlbumEmptyWidget();
    }

    final feeds = viewModel.items;
    final hasFooter = viewModel.isLoadingMore || viewModel.hasError;

    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: MyColor.white,
      onRefresh: () => context.read<FeedTabViewModel>().init(),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: feeds.length + (hasFooter ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == feeds.length) {
            if (viewModel.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (viewModel.hasError) {
              return RetryWidget(
                onRetry: () => context.read<FeedTabViewModel>().retry(),
              );
            }
            return null;
          }
          final albumId = feeds[index];
          return FeedWidget(
            key: ValueKey(albumId),
            feed: cache.postOf(albumId)!,
            stat: cache.statOf(albumId),
            isLocked: !cache.isUnlocked(albumId),
            onToggleLike: () => viewModel.toggleLike(albumId),
            onDelete: () => viewModel.deleteFeed(albumId),
            onRequestUnlock: () => _requestUnlock(albumId),
            isContentExpanded: viewModel.isContentExpanded(albumId),
            onContentExpandChanged: (expanded) =>
                viewModel.setContentExpanded(albumId, expanded),
          );
        },
      ),
    );
  }
}
