part of '../goal_screen.dart';

class _GoalErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _GoalErrorWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WidyuAssetImage(
                name: 'img_100_mascot_crying.png', width: 100),
            const SizedBox(height: 16),
            Text(
              '목표 정보를 불러오지 못했어요.',
              textAlign: TextAlign.center,
              style: MyTypo.title2.copyWith(color: MyColor.grey700),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 160,
              child:
                  WidyuTextButton(onTap: onRetry, text: '다시 시도', enable: true),
            ),
          ],
        ),
      ),
    );
  }
}
