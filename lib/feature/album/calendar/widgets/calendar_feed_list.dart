part of '../calendar_tab_view.dart';

class _CalendarFeedList extends StatelessWidget {
  const _CalendarFeedList({
    required this.albumIds,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasError,
    required this.controller,
    required this.onRetry,
    required this.itemBuilder,
  });

  final List<int> albumIds;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final ScrollController controller;
  final VoidCallback onRetry;
  final Widget Function(int albumId) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CustomLoadingWidget();
    }

    if (albumIds.isEmpty) {
      if (hasError) {
        return CustomErrorWidget(
          errorMsg: '피드를 불러오지 못했어요',
          onRetry: onRetry,
        );
      }
      return Center(
        child: Text(
          '게시물이 없어요🥲',
          style: MyTypo.title2.copyWith(color: MyColor.grey300),
        ),
      );
    }

    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: albumIds.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == albumIds.length) return _buildFooter();

        return itemBuilder(albumIds[index]);
      },
    );
  }

  Widget _buildFooter() {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasError) {
      return RetryWidget(onRetry: onRetry);
    }
    return const SizedBox.shrink();
  }
}
