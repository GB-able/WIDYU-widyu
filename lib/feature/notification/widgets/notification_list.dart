part of '../notification_screen.dart';

class _NotificationList extends ConsumerStatefulWidget {
  const _NotificationList();

  @override
  ConsumerState<_NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<_NotificationList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreIfShort();
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
      ref.read(notificationViewModelProvider.notifier).loadMore();
    }
  }

  void _loadMoreIfShort() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) _onScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);
    final notifications = uiState.list.items;
    ref
      ..listen(
        notificationViewModelProvider.select((state) => state.category),
        (_, __) {
          if (_scrollController.hasClients) _scrollController.jumpTo(0);
        },
      )
      ..listen(
        notificationViewModelProvider.select((state) => state.list.items),
        (_, __) => _loadMoreIfShort(),
      );

    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: Colors.white,
      onRefresh: viewModel.load,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length + 1,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, color: MyColor.grey100),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            if (uiState.list.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: MyColor.primary),
                ),
              );
            }
            if (uiState.list.hasError) {
              return Center(
                child: TextButton(
                  onPressed: viewModel.retry,
                  child: const Text(
                    '다시 시도',
                    style: TextStyle(color: MyColor.primary),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final notification = notifications[index];

          return _NotificationTile(
            notification: notification,
            categoryName: uiState.nameOf(notification.category),
            onTap: () {
              viewModel.read(notification);
              GoRouter.of(context).openDeepLink(notification.path);
            },
          );
        },
      ),
    );
  }
}
