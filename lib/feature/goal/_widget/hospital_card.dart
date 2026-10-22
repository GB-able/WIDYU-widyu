import 'package:flutter/material.dart';
import 'package:widyu/core/model/goal/hospital/hospital.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';
import 'package:widyu/feature/goal/_widget/icon_tile.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';

class HospitalCard extends StatelessWidget {
  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onTap,
    required this.findRoute,
  });

  final Hospital hospital;
  final VoidCallback onTap;
  final VoidCallback findRoute;

  @override
  Widget build(BuildContext context) {
    final dday = hospital.dday;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 16,
          children: [
            Row(
              spacing: 16,
              children: [
                const IconTile(type: GoalType.hospital),
                Expanded(
                  child: Row(
                    spacing: 16,
                    children: [
                      Flexible(
                        child: Text(
                          hospital.name,
                          style: MyTypo.title3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "D-${dday <= 0 ? "day" : dday}",
                        style: MyTypo.title3.copyWith(color: MyColor.primary),
                      ),
                    ],
                  ),
                ),
                // const IconWidget(
                //   icon: "chevron_right",
                //   width: 16,
                //   color: MyColor.grey500,
                // ),
              ],
            ),
            Column(
              spacing: 8,
              children: [
                _HospitalInfo(
                  label: '건강일정',
                  content: IntrinsicHeight(
                    child: Row(
                      spacing: 12,
                      children: [
                        Text(
                          hospital.datetime.onlyMonthDay,
                          style: MyTypo.body1.copyWith(color: MyColor.grey700),
                        ),
                        Container(width: 1, height: 15, color: MyColor.grey700),
                        Text(
                          hospital.datetime.onlyTime.twelveHourTime,
                          style: MyTypo.body1.copyWith(color: MyColor.grey700),
                        ),
                      ],
                    ),
                  ),
                ),
                _HospitalInfo(
                  label: '방문주소',
                  content: Text(
                    hospital.address,
                    style: MyTypo.body1.copyWith(color: MyColor.grey700),
                  ),
                ),
              ],
            ),
            _FindRouteBtn(findRoute: findRoute),
            // hospital.isReward ?? false
            //     ? PointGetBtn(point: 20, onTap: () {})
            //     : _FindRouteBtn(findRoute: findRoute)
          ],
        ),
      ),
    );
  }
}

class _HospitalInfo extends StatelessWidget {
  const _HospitalInfo({required this.label, required this.content});

  final String label;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 60,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColor.grey100,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: MyTypo.subTitle2.copyWith(color: MyColor.grey500),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}

class _FindRouteBtn extends StatelessWidget {
  const _FindRouteBtn({required this.findRoute});

  final VoidCallback findRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: findRoute,
      child: Container(
        width: double.infinity,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: MyColor.primary),
        child:
            Text('길 찾기', style: MyTypo.button.copyWith(color: MyColor.white)),
      ),
    );
  }
}
