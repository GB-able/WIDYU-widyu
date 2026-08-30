import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

/// 텍스트만 있는 기본 버튼
///
/// 색상을 지정하지 않으면 활성 상태는 [MyColor.primary] + [MyColor.white],
/// 비활성 상태는 [MyColor.grey100] + [MyColor.grey300]을 사용한다.
class WidyuTextButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final bool enable;

  /// 활성 상태의 배경색
  final Color backgroundColor;

  /// 활성 상태의 텍스트 색상
  final Color textColor;

  /// 비활성 상태의 배경색
  final Color disabledBackgroundColor;

  /// 비활성 상태의 텍스트 색상
  final Color disabledTextColor;

  const WidyuTextButton({
    super.key,
    required this.onTap,
    required this.text,
    this.enable = true,
    this.backgroundColor = MyColor.primary,
    this.textColor = MyColor.white,
    this.disabledBackgroundColor = MyColor.grey100,
    this.disabledTextColor = MyColor.grey300,
  });

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(6));

    // [Ink] 는 배경을 자기 자리가 아니라 가장 가까운 [Material] 의 캔버스에 그린다.
    // 그 사이에 배경색을 가진 위젯이 끼면 잉크가 가려져 색이 보이지 않으므로,
    // 배경은 이 위젯이 소유한 [Material] 이 직접 칠하게 한다.
    return Material(
      color: enable ? backgroundColor : disabledBackgroundColor,
      borderRadius: radius,
      child: InkWell(
        onTap: enable ? onTap : null,
        borderRadius: radius,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Center(
            child: Text(
              text,
              style: MyTypo.button.copyWith(
                color: enable ? textColor : disabledTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
