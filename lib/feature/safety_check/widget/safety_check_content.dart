part of '../safety_check_screen.dart';

class _SafetyCheckContent extends StatelessWidget {
  const _SafetyCheckContent({required this.deadline, required this.onCancel});

  final DateTime? deadline;
  final Future<bool> Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 40,
          children: [
            Column(
              spacing: 16,
              children: [
                WiduIcon(
                  icon: Assets.icons.ic66Warning,
                  width: 66,
                  height: 66,
                ),
                Text(
                  '평소와 다른 심박이\n감지됐어요.',
                  textAlign: TextAlign.center,
                  style: MyTypo.subTitle6.copyWith(
                    color: MyColor.white,
                    letterSpacing: -0.4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '괜찮으시다면 정해진 시간 안에 버튼을 눌러주세요. 응답이 없을 경우 보호자분께 안부를 전해드려요.'
                        .split(' ')
                        .map((word) => word.split('').join('‍'))
                        .join(' '),
                    textAlign: TextAlign.center,
                    style: MyTypo.body1.copyWith(color: MyColor.white),
                  ),
                ),
                if (deadline case final deadline?)
                  _RemainingSeconds(deadline: deadline),
              ],
            ),
            _SlideButton(onCompleted: onCancel),
          ],
        ),
      ),
    );
  }
}
