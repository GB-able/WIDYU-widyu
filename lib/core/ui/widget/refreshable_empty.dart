import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class RefreshableEmpty extends StatelessWidget {
  const RefreshableEmpty({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyColor.primary,
      backgroundColor: MyColor.white,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(hasScrollBody: false, child: child),
        ],
      ),
    );
  }
}
