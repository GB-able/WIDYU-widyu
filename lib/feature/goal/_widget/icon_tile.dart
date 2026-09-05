import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.type, this.isFailed = false});

  final GoalType type;
  final bool isFailed;

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
        child: Image.asset(
          "assets/images/img_40_${type.name}${isFailed ? "_disabled" : ""}.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
