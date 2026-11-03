part of '../profile_screen.dart';

class _ProfileImageView extends StatelessWidget {
  final String profileImage;
  final ValueChanged<File> onImagePicked;

  const _ProfileImageView({
    required this.profileImage,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;
    onImagePicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: IgnorePointer(
              child: profileImage.isEmpty
                  ? WiduIcon(
                      icon: Assets.icons.ic104Profile,
                      width: 104,
                      height: 104,
                    )
                  : Image.network(
                      profileImage,
                      width: 104,
                      height: 104,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 104,
                          height: 104,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => WiduIcon(
                        icon: Assets.icons.ic104Profile,
                        width: 104,
                        height: 104,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: MyColor.white,
              shape: BoxShape.circle,
            ),
            child: Material(
              color: MyColor.transparent,
              child: InkWell(
                onTap: _pickImage,
                customBorder: const CircleBorder(),
                child: WiduIcon(
                  icon: Assets.icons.ic24PlusOrange,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
