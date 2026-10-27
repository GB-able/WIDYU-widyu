part of '../notification_screen.dart';

class _NotificationList extends StatefulWidget {
  const _NotificationList();

  @override
  State<_NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<_NotificationList> {
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
      context.read<NotificationViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    final notifications = viewModel.items;

    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: Colors.white,
      onRefresh: () => context.read<NotificationViewModel>().load(),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: notifications.length + 1,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, thickness: 1, color: MyColor.grey100),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            if (viewModel.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(color: MyColor.primary),
                ),
              );
            }
            if (viewModel.hasError) {
              return Center(
                child: TextButton(
                  onPressed: () =>
                      context.read<NotificationViewModel>().retry(),
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
            categoryName: viewModel.uiState.nameOf(notification.category),
            onTap: () {
              context.read<NotificationViewModel>().read(notification);
              final uri = Uri.tryParse(notification.path);
              final canGo = notification.path.isNotEmpty &&
                  uri != null &&
                  GoRouter.of(context).configuration.findMatch(uri).isNotEmpty;
              if (canGo) context.push(notification.path);
            },
          );
        },
      ),
    );
  }
}
