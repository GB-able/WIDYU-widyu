part of '../home_screen.dart';

class _LocationSharingBanner extends StatelessWidget {
  final bool hasBackgroundLocation;
  final bool isLocationServiceEnabled;
  final bool hasServiceError;
  final VoidCallback onSetup;

  const _LocationSharingBanner({
    required this.hasBackgroundLocation,
    required this.isLocationServiceEnabled,
    required this.hasServiceError,
    required this.onSetup,
  });

  @override
  Widget build(BuildContext context) {
    final message = hasServiceError
        ? '위치 공유를 시작하지 못했어요. 다시 설정해 주세요.'
        : !hasBackgroundLocation
            ? '위치 항상 허용이 필요해요.'
            : !isLocationServiceEnabled
                ? '기기의 위치 서비스를 켜 주세요.'
                : '위치 공유를 설정해 주세요.';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColor.orange50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위치 공유 중지', style: MyTypo.subTitle4),
              Text(message,
                  style: MyTypo.helper.copyWith(color: MyColor.grey700)),
            ],
          )),
          TextButton(
            onPressed: onSetup,
            child: const Text('위치 공유 설정하기'),
          ),
        ],
      ),
    );
  }
}
