part of '../home_screen.dart';

class _RewardDialog extends StatelessWidget {
  final int point;

  const _RewardDialog({required this.point});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColor.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColor.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text(
                  '리워드 획득',
                  style: MyTypo.title2.copyWith(color: MyColor.grey800),
                ),
                const SizedBox(height: 8),
                Text(
                  '${point}P',
                  style: MyTypo.largeTitle.copyWith(color: MyColor.primary),
                ),
                const SizedBox(height: 24),
                Material(
                  type: MaterialType.transparency,
                  child: TextBtn(
                    onTap: () => Navigator.of(context).pop(),
                    text: '확인',
                    enable: true,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _RewardCloseButton(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RewardCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColor.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: WidyuIcon(
            icon: 'ic_16_close.svg',
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }
}
