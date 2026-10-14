import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({super.key, this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            Text(
              message,
              style: MyTypo.body1.copyWith(color: MyColor.grey700),
            ),
            const SizedBox(height: 8),
          ],
          TextButton(
            onPressed: onRetry,
            child: Text(
              "다시 시도",
              style: MyTypo.body2.copyWith(color: MyColor.primary),
            ),
          ),
        ],
      ),
    );
  }
}
