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
    return Skeletonizer(
      enabled: isLoading,
      child: Row(
        children: [
          _profileImageView(profileImage),
          const SizedBox(width: 16),
          Text(
            isLoading ? '홍길동' : (name ?? "-"),
            style: MyTypo.title4.copyWith(color: MyColor.white),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              await context.push(AppRoute.profile.path);
              if (context.mounted) {
                context.read<MyPageViewModel>().fetchUser();
              }
            },
            icon: SvgPicture.asset(
              'assets/icons/ic_20_chevron_right_large.svg',
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(MyColor.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _profileImageView(String? profileImage) {
  return Container(
    padding: const EdgeInsets.all(4),
    width: 76,
    height: 76,
    decoration: const BoxDecoration(shape: BoxShape.circle),
    clipBehavior: Clip.hardEdge,
    child: profileImage == null || profileImage.isEmpty
        ? SvgPicture.asset(
            'assets/icons/ic_76_profile.svg',
            width: 76,
            height: 76,
          )
        : Image.network(
            profileImage,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                width: 76,
                height: 76,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (_, __, ___) => SvgPicture.asset(
              'assets/icons/ic_76_profile.svg',
              width: 76,
              height: 76,
            ),
          ),
  );
}
