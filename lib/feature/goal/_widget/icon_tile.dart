import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/gen/assets.gen.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.type, this.isFailed = false});

  final GoalType type;
  final bool isFailed;

  AssetGenImage get _image => switch ((type, isFailed)) {
        (GoalType.medicine, false) => Assets.images.img40Medicine,
        (GoalType.medicine, true) => Assets.images.img40MedicineDisabled,
        (GoalType.walk, false) => Assets.images.img40Walk,
        (GoalType.walk, true) => Assets.images.img40WalkDisabled,
        (GoalType.hospital, false) => Assets.images.img40Hospital,
        (GoalType.hospital, true) => Assets.images.img40HospitalDisabled,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: _image.image(fit: BoxFit.cover),
      ),
    );
  }
}
