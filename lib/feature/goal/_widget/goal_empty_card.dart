import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/gen/assets.gen.dart';

extension GoalTypeUI on GoalType {
  String get title => switch (this) {
        GoalType.medicine => '복용할 약이 없어요!',
        GoalType.walk => '걷기 목표가 없어요!',
        GoalType.hospital => '건강 일정이 없어요!',
      };

  String get subTitle => switch (this) {
        GoalType.medicine => '복용하실 약을 추가하고 알림을 받아보세요.',
        GoalType.walk => '달성할 걷기를 추가하고 알림을 받아보세요.',
        GoalType.hospital => '예약한 병원 일정을 추가하고 알림을 받아보세요.',
      };

  AssetGenImage get image => switch (this) {
        GoalType.medicine => Assets.images.img50Medicine,
        GoalType.walk => Assets.images.img50Walk,
        GoalType.hospital => Assets.images.img50Hospital,
      };
}

class GoalEmptyCard extends StatelessWidget {
  const GoalEmptyCard({super.key, required this.type});

  final GoalType type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // [TODO] 유형 별 터치 로직 추가 예정
      onTap: () {
        switch (type) {
          case GoalType.medicine:
            break;
          case GoalType.walk:
            break;
          case GoalType.hospital:
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: MyColor.white,
        ),
        child: Column(
          children: [
            type.image.image(
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 4),
            Text(
              type.title,
              style: MyTypo.title2.copyWith(color: MyColor.grey700),
            ),
            const SizedBox(height: 8),
            Text(
              type.subTitle,
              style: MyTypo.body2.copyWith(color: MyColor.grey500),
            ),
            const SizedBox(height: 12),
            // GestureDetector(
            //   onTap: () {
            //     switch (type) {
            //       // [TODO] 유형 별 수정 로직 추가 예정
            //       case GoalType.medicine:
            //       case GoalType.walk:
            //       case GoalType.hospital:
            //     }
            //   },
            //   child: Container(
            //     height: 40,
            //     decoration: BoxDecoration(
            //       color: MyColor.grey50,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Row(
            //       spacing: 4,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         WiduIcon(
            //           icon: Assets.icons.ic24PlusSmall,
            //           width: 24,
            //           color: MyColor.primary,
            //         ),
            //         Text(
            //           "추가하기",
            //           style: MyTypo.subTitle2.copyWith(color: MyColor.primary),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
