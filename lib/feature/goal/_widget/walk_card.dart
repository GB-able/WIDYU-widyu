import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:widyu/core/model/goal/walk/walk.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/extensions/int_extension.dart';
import 'package:widyu/feature/goal/_widget/done_tag.dart';
import 'package:widyu/feature/goal/_widget/icon_tile.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';

enum WalkCardType { goal, walk }

class WalkCard extends StatelessWidget {
  const WalkCard({
    super.key,
    required this.walk,
    this.onTap,
  });

  final Walk walk;
  final VoidCallback? onTap;

  static const _countUpDuration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 20,
          children: [
            Row(
              spacing: 16,
              children: [
                const IconTile(type: GoalType.walk),
                Text('걷기', style: MyTypo.title3),
                Expanded(
                  child: TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: walk.actual),
                    duration: _countUpDuration,
                    curve: Curves.easeOut,
                    builder: (context, steps, _) => Text(
                      '${steps.toComma}걸음',
                      style: MyTypo.title3.copyWith(
                        color: MyColor.secondary,
                      ),
                    ),
                  ),
                ),
                if (walk.actual >= walk.goal) const DoneTag(isFailed: false),
              ],
            ),
            LinearPercentIndicator(
              animation: true,
              animateFromLastPercent: true,
              animationDuration: _countUpDuration.inMilliseconds,
              percent: (walk.actual / walk.goal).clamp(0.0, 1.0),
              linearGradient: const LinearGradient(
                colors: [MyColor.purple200, MyColor.purple500],
              ),
              backgroundColor: MyColor.purple100,
              lineHeight: 14,
              padding: EdgeInsets.zero,
              barRadius: const Radius.circular(14),
            ),
            // CardEditBtn(
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
