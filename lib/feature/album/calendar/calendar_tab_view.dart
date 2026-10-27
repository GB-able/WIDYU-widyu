import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_error_widget.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/utils/calendar_config.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';
import 'package:widyu/feature/album/_widgets/retry_widget.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_view_model.dart';

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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarTabViewModel(
        repository: context.read<AlbumRepository>(),
        albumProvider: context.read<AlbumProvider>(),
      )..init(),
      child: const _CalendarTabContent(),
    );
  }
}

class _CalendarTabContent extends StatefulWidget {
  const _CalendarTabContent();

  @override
  State<_CalendarTabContent> createState() => _CalendarTabContentState();
}

class _CalendarTabContentState extends State<_CalendarTabContent>
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
      context.read<CalendarTabViewModel>().loadMoreFeeds();
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarTabViewModel>();

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
              viewModel: viewModel,
              shrink: _shrink,
              onHandleTap: _toggleHeader,
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: _CalendarFeedList(
              viewModel: viewModel,
              controller: _scrollController,
            ),
          ),
        ),
      ],
    );
  }
}
