import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

/// 위듀 다이얼로그의 공통 외형. 내용과 닫기 동작은 호출부에서 구성한다.
class WidyuDialog extends StatelessWidget {
  final Widget child;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onClose;

  const WidyuDialog({
    super.key,
    required this.child,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 24),
    this.contentPadding = const EdgeInsets.all(16),
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColor.transparent,
      insetPadding: insetPadding,
      child: Stack(
        children: [
          Container(
            padding: contentPadding,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColor.white,
            ),
            child: child,
          ),
          if (onClose != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: MyColor.transparent,
                child: InkWell(
                  onTap: onClose,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: WiduIcon(
                      icon: Assets.icons.ic16Close,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
