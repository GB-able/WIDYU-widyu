part of '../emergency_confirm_screen.dart';

class _EmergencyConfirmContent extends StatelessWidget {
  const _EmergencyConfirmContent({required this.onCancel});

  final Future<bool> Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 40,
        children: [
          Column(
            spacing: 16,
            children: [
              const WidyuIcon(
                icon: 'ic_66_warning.svg',
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
              Text(
                '괜찮으시면 시간 안에 누르지 않으면\n보호자에게 알려드려요.',
                textAlign: TextAlign.center,
                style: MyTypo.body1.copyWith(color: MyColor.white),
              ),
            ],
          ),
          _SlideButton(onCompleted: onCancel),
        ],
      ),
    );
  }
}
