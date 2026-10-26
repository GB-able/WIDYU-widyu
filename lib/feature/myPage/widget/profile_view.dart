part of '../my_page_screen.dart';

class _ProfileView extends StatelessWidget {
  final bool isLoading;
  final String? profileImage;
  final String? name;

  const _ProfileView({
    this.isLoading = false,
    this.profileImage,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _profileImageView(profileImage, isLoading),
        const SizedBox(width: 16),
        Skeletonizer(
          enabled: isLoading,
          child: Text(
            isLoading ? '홍길동' : (name ?? '-'),
            style: MyTypo.title4.copyWith(color: MyColor.white),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            await context.push(AppRoute.profile.path);
            if (context.mounted) {
              context.read<MyPageViewModel>().fetchUser();
            }
          },
          icon: const WidyuIcon(
            icon: 'ic_20_chevron_right_large.svg',
            width: 20,
            height: 20,
            color: MyColor.white,
          ),
        ),
      ],
    );
  }
}

Widget _profileImageView(String? profileImage, bool isLoading) {
  return Container(
    width: 76,
    height: 76,
    decoration: const BoxDecoration(shape: BoxShape.circle),
    clipBehavior: Clip.hardEdge,
    child: isLoading
        ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
        : (profileImage == null || profileImage.isEmpty)
            ? const WidyuIcon(
                icon: 'ic_76_profile.svg',
                width: 76,
                height: 76,
              )
            : Image.network(
                profileImage,
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) => const WidyuIcon(
                  icon: 'ic_76_profile.svg',
                  width: 76,
                  height: 76,
                ),
              ),
  );
}
