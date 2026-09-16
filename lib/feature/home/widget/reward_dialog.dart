part of '../home_screen.dart';

class _RewardDialog extends StatelessWidget {
  final int point;
  final int totalPoint;

  const _RewardDialog({required this.point, required this.totalPoint});

  @override
  Widget build(BuildContext context) {
    return WidyuDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      onClose: () => context.pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const WidyuAssetImage(
            name: 'img_125_check.png',
            width: 125,
            height: 125,
          ),
          const SizedBox(height: 16),
          Text(
            '리워드 획득!',
            style: MyTypo.title2.copyWith(color: MyColor.black),
          ),
          const SizedBox(height: 8),
          Text(
            '${point}P',
            style: MyTypo.title1.copyWith(color: MyColor.primary),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: MyColor.grey100,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                Text(
                  '잔여 포인트',
                  style: MyTypo.subTitle2.copyWith(color: MyColor.grey600),
                ),
                const Spacer(),
                Text(
                  '${totalPoint}P',
                  style: MyTypo.title2.copyWith(color: MyColor.grey600),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Material(
            type: MaterialType.transparency,
            child: WidyuTextButton(
              onTap: () => context.pop(),
              text: '목표로 이동하기',
              enable: true,
            ),
          ),
        ],
      ),
    );
  }
}
