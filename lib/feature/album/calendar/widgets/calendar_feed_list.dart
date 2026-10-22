part of '../calendar_tab_view.dart';

class _CalendarFeedList extends StatelessWidget {
  const _CalendarFeedList({required this.viewModel, required this.controller});

  final CalendarTabViewModel viewModel;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoadingSelectedDay) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final feeds = viewModel.selectedDayAlbumIds;

    if (feeds.isEmpty) {
      if (viewModel.hasErrorSelectedDay) {
        return RetryWidget(
          message: '피드를 불러오지 못했어요',
          onRetry: () => viewModel.retry(),
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
      itemCount: feeds.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == feeds.length) return _buildFooter();

        final albumId = feeds[index];
        return FeedWidget(
          key: ValueKey(albumId),
          albumId: albumId,
          isContentExpanded: viewModel.isContentExpanded(albumId),
          onContentExpandChanged: (expanded) =>
              viewModel.setContentExpanded(albumId, expanded),
        );
      },
    );
  }

  Widget _buildFooter() {
    if (viewModel.isLoadingMoreSelectedDay) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (viewModel.hasErrorSelectedDay) {
      return RetryWidget(onRetry: () => viewModel.retry());
    }
    return const SizedBox.shrink();
  }
}
