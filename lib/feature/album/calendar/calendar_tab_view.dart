import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/calendar_config.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/calendar_feed_list.dart';
part 'widgets/calendar_grid.dart';
part 'widgets/calendar_header_view.dart';

abstract class _HeaderMetrics {
  static const topPadding = 8.0;
  static const headerHeight = 40.0;
  static const daysOfWeekHeight = 44.0;
  static const rowHeight = 44.0;
  static const monthRows = 6;
  static const spacing = 20.0;
  static const handleAreaHeight = 20.0;

  static const gridMaxHeight = daysOfWeekHeight + rowHeight * monthRows;
  static const gridMinHeight = daysOfWeekHeight + rowHeight;

  static const maxHeight =
      topPadding + headerHeight + gridMaxHeight + spacing + handleAreaHeight;
  static const minHeight = topPadding + headerHeight + handleAreaHeight;

  static const shrinkRange = maxHeight - minHeight;
  static const monthToWeekBudget = gridMaxHeight - gridMinHeight;
  static const weekHideBudget = gridMinHeight;

  static const oneRowShrink = monthToWeekBudget;
  static const snapPoints = [0.0, oneRowShrink, shrinkRange];
}

class CalendarTabView extends StatelessWidget {
  const CalendarTabView({super.key});

  @override
  Widget build(BuildContext context) => const _CalendarTabContent();
}

class _CalendarTabContent extends ConsumerStatefulWidget {
  const _CalendarTabContent();

  @override
  ConsumerState<_CalendarTabContent> createState() =>
      _CalendarTabContentState();
}

class _CalendarTabContentState extends ConsumerState<_CalendarTabContent>
    with SingleTickerProviderStateMixin {
  static const _snapDuration = Duration(milliseconds: 250);
  static const _flingVelocityThreshold = 200.0;

  final _scrollController = ScrollController();
  late final AnimationController _shrinkController;

  @override
  void initState() {
    super.initState();
    _shrinkController = AnimationController(
      vsync: this,
      duration: _snapDuration,
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _shrinkController.dispose();
    super.dispose();
  }

  double get _shrink => _shrinkController.value * _HeaderMetrics.shrinkRange;

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(calendarTabViewModelProvider.notifier).loadMoreFeeds();
    }
  }

  void _applyShrinkDelta(double delta) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      return;
    }
    if (_shrinkController.isAnimating) _shrinkController.stop();

    final next = (_shrink + delta).clamp(0.0, _HeaderMetrics.shrinkRange);
    _shrinkController.value = next / _HeaderMetrics.shrinkRange;
  }

  double _snapTarget(double velocity) {
    const points = _HeaderMetrics.snapPoints;
    final shrink = _shrink;

    if (velocity.abs() < _flingVelocityThreshold) {
      return points.reduce(
        (a, b) => (shrink - a).abs() <= (shrink - b).abs() ? a : b,
      );
    }
    if (velocity > 0) {
      for (final point in points) {
        if (point > shrink + 0.5) return point;
      }
      return points.last;
    }
    for (final point in points.reversed) {
      if (point < shrink - 0.5) return point;
    }
    return points.first;
  }

  void _snap({double velocity = 0}) {
    final target = _snapTarget(velocity);
    if ((target - _shrink).abs() < 0.5) return;

    _shrinkController.animateTo(
      target / _HeaderMetrics.shrinkRange,
      duration: _snapDuration,
      curve: Curves.easeOutCubic,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0 && notification.dragDetails != null) {
        _applyShrinkDelta(notification.overscroll);
      }
    } else if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta;
      if (delta == null || delta <= 0) return false;
      _applyShrinkDelta(delta);
    } else if (notification is ScrollEndNotification) {
      _snap(velocity: -(notification.dragDetails?.primaryVelocity ?? 0));
    }
    return false;
  }

  void _toggleHeader() {
    _shrinkController.animateTo(
      _shrinkController.value > 0.01 ? 0.0 : 1.0,
      duration: _snapDuration,
      curve: Curves.easeInOut,
    );
  }

  // 탭 시점의 캐시와 포인트로 판단한다.
  Future<bool> _requestUnlock(int albumId) async {
    final repository = ref.read(albumRepositoryProvider);
    final cache = repository.currentCache;
    final success = await showUnlockDialog(
      context,
      price: cache.postOf(albumId)?.price,
      pointRepository: ref.read(pointRepositoryProvider),
      isUnlocking: cache.isUnlocking(albumId),
      onPurchase: () => repository.unlock(albumId),
      onGoToGoal: () => context.go(AppRoute.goal.path),
    );
    return success && !repository.isDisposed;
  }

  // 행마다 자기 게시물 데이터만 구독한다.
  Widget _buildFeed(int albumId) {
    return Consumer(
      key: ValueKey(albumId),
      builder: (context, ref, _) {
        final (post, stat, isUnlocked, isContentExpanded) = ref.watch(
          calendarTabViewModelProvider.select(
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
        final viewModel = ref.watch(calendarTabViewModelProvider.notifier);
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
  }

  @override
  Widget build(BuildContext context) {
    // 달력은 월·선택일·일정 있는 날만 구독하고, 피드 목록은 아래 Consumer로 따로 구독한다.
    final viewModel = ref.watch(calendarTabViewModelProvider.notifier);
    final (focusedMonth, selectedDay, daysWithEvents) = ref.watch(
      calendarTabViewModelProvider.select(
        (s) => (s.focusedMonth, s.selectedDay, s.daysWithEvents),
      ),
    );

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragUpdate: (details) =>
              _applyShrinkDelta(-details.delta.dy),
          onVerticalDragEnd: (details) =>
              _snap(velocity: -(details.primaryVelocity ?? 0)),
          child: AnimatedBuilder(
            animation: _shrinkController,
            builder: (context, _) => _CalendarHeaderView(
              focusedMonth: focusedMonth,
              selectedDay: selectedDay,
              hasEvent: (day) =>
                  day.isSameMonth(focusedMonth) &&
                  daysWithEvents.contains(day.day),
              onPageChanged: viewModel.onPageChanged,
              onSelectDay: viewModel.selectDay,
              shrink: _shrink,
              onHandleTap: _toggleHeader,
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: Consumer(
              builder: (context, ref, _) {
                final feedState = ref.watch(
                  calendarTabViewModelProvider.select(
                    (s) => s.selectedDayState,
                  ),
                );
                return _CalendarFeedList(
                  albumIds: feedState.albumIds,
                  isLoading: feedState.isLoading,
                  isLoadingMore: feedState.isLoadingMore,
                  hasError: feedState.hasError,
                  controller: _scrollController,
                  onRetry: viewModel.retry,
                  itemBuilder: _buildFeed,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
