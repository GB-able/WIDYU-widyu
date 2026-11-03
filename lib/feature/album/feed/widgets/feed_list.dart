part of '../feed_tab_view.dart';

class _FeedList extends ConsumerStatefulWidget {
  const _FeedList();

  @override
  ConsumerState<_FeedList> createState() => _FeedListState();
}

class _FeedListState extends ConsumerState<_FeedList> {
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
      ref.read(feedTabViewModelProvider.notifier).loadMore();
    }
  }

  // 탭 시점의 캐시와 포인트로 판단한다.
  Future<bool> _requestUnlock(int albumId) async {
    final repository = ref.read(albumRepositoryProvider);
    final cache = repository.currentCache;
    final success = await showUnlockDialog(
      context,
      price: cache.postOf(albumId)?.price,
      point: ref.read(pointRepositoryProvider).currentStatus.point,
      isUnlocking: cache.isUnlocking(albumId),
      onPurchase: () => repository.unlock(albumId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  @override
  Widget build(BuildContext context) {
    // 목록 단위 상태만 구독하고, 각 행은 아래 Consumer로 자기 데이터만 구독한다.
    final viewModel = ref.watch(feedTabViewModelProvider.notifier);
    final list = ref.watch(feedTabViewModelProvider.select((s) => s.list));
    final InfiniteScrollState(:isLoading, :hasError, :isLoadingMore) = list;
    final feeds = list.items;

    if (isLoading) {
      return const CustomLoadingWidget();
    }

    if (feeds.isEmpty) {
      if (hasError) {
        return CustomErrorWidget(
          errorMsg: '피드를 불러오지 못했어요',
          onRetry: viewModel.retry,
        );
      }
      return const AlbumEmptyWidget();
    }

    final hasFooter = isLoadingMore || hasError;

    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: MyColor.white,
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: feeds.length + (hasFooter ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == feeds.length) {
            if (isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (hasError) {
              return RetryWidget(onRetry: viewModel.retry);
            }
            return null;
          }
          final albumId = feeds[index];
          return Consumer(
            key: ValueKey(albumId),
            builder: (context, ref, _) {
              final (post, stat, isUnlocked, isContentExpanded) = ref.watch(
                feedTabViewModelProvider.select(
                  (s) => (
                    s.cache.postOf(albumId),
                    s.cache.statOf(albumId),
                    s.cache.isUnlocked(albumId),
                    s.expandedFeedIds.contains(albumId),
                  ),
                ),
              );
              // 행은 목록과 따로 구독하므로 캐시에서 빠진 게시물일 수 있다.
              if (post == null) return const SizedBox.shrink();
              return FeedWidget(
                feed: post,
                stat: stat,
                isLocked: !isUnlocked,
                onToggleLike: () => viewModel.toggleLike(albumId),
                onDelete: () => viewModel.deleteFeed(albumId),
                onRequestUnlock: () => _requestUnlock(albumId),
                isContentExpanded: isContentExpanded,
                onContentExpandChanged: (expanded) =>
                    viewModel.setContentExpanded(albumId, expanded),
              );
            },
          );
        },
      ),
    );
  }
}
