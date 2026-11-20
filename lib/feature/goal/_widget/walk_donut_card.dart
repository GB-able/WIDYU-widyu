import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/extensions/int_extension.dart';
import 'package:widyu/feature/goal/_widget/icon_tile.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';

/// 걸음 수와 목표, 도넛 그래프. 목표를 채우면 보라색으로 바뀐다.
class WalkDonutCard extends StatelessWidget {
  const WalkDonutCard({
    super.key,
    required this.actual,
    required this.goal,
    this.color = MyColor.white,
  });

  final int actual;
  final int goal;

  /// 카드 배경. 흰 화면 위에 놓이면 회색으로 바꾼다.
  final Color color;

  static const _orange = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [MyColor.orange300, MyColor.primary],
  );
  static const _purple = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [MyColor.purple200, MyColor.purple600],
  );

  @override
  Widget build(BuildContext context) {
    final percent = goal > 0 ? (actual / goal).clamp(0.0, 1.0) : 0.0;
    final isDone = percent >= 1;
    final countColor = isDone ? MyColor.secondary : MyColor.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    const IconTile(type: GoalType.walk),
                    Text('걷기',
                        style: MyTypo.title3.copyWith(color: MyColor.grey800)),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: actual.toComma,
                        style: TextStyle(color: countColor),
                      ),
                      TextSpan(text: '  / ${goal.toComma}'),
                    ],
                  ),
                  style: MyTypo.title1.copyWith(color: MyColor.grey500),
                ),
              ],
            ),
          ),
          CircularPercentIndicator(
            radius: 40,
            lineWidth: 21,
            percent: percent,
            // 위에서 시작해 반시계 방향으로 채운다.
            reverse: true,
            animation: true,
            animateFromLastPercent: true,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: MyColor.grey100,
            // 0%일 때 둥근 끝이 점으로 찍히지 않게 진행 색을 지운다.
            // 그라데이션과 진행 색을 함께 주면 ArgumentError가 난다.
            progressColor: percent == 0 ? Colors.transparent : null,
            linearGradient: percent == 0 ? null : (isDone ? _purple : _orange),
          ),
        ],
      ),
    );
  }
}
