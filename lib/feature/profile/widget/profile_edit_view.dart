part of '../profile_screen.dart';

class _ProfileEditView extends StatelessWidget {
  final String name;
  final String? profileImage;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<File> onImagePicked;

  const _ProfileEditView({
    required this.name,
    required this.profileImage,
    required this.onNameChanged,
    required this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileImageView(
          profileImage: profileImage,
          onImagePicked: onImagePicked,
        ),
        const SizedBox(height: 12),
        _ProfileNameView(
          name: name,
          onNameChanged: onNameChanged,
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
