part of '../select_photo_screen.dart';

class _PermissionDeniedWidget extends StatelessWidget {
  const _PermissionDeniedWidget({required this.viewModel});

  final SelectPhotoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/img_100_photo.png', width: 100),
        const SizedBox(height: 16),
        Text(
          '앨범 접근 권한이 필요합니다!',
          style: MyTypo.title2.copyWith(color: MyColor.grey700),
        ),
        const SizedBox(height: 8),
        Text(
          '사진과 비디오를 불러오고 공유하려면\n앨범에 대한 접근 권한을 허용해 주세요.\n설정에서 언제든지 변경할 수 있습니다.',
          style: MyTypo.body2.copyWith(color: MyColor.grey500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
