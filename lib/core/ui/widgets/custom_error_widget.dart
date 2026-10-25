import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.errorMsg = "오류가 발생했습니다.\n다시 시도해주세요.",
    this.onRetry,
  });

  final String errorMsg;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          const Spacer(flex: 2),
          const Icon(Icons.error_rounded, size: 48, color: MyColor.grey500),
          Text(
            errorMsg,
            style: MyTypo.body2.copyWith(color: MyColor.grey600),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text(
                "다시 시도",
                style: TextStyle(color: MyColor.primary),
              ),
            ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
