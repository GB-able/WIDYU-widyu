part of '../my_page_screen.dart';

class _MyPageHeader extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final int? points;
  final bool isLoading;

  const _MyPageHeader({
    required this.profileImage,
    required this.name,
    required this.points,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 24),
      decoration: const BoxDecoration(
        color: MyColor.orange400,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: _HeaderContent(
        profileImage: profileImage,
        name: name,
        points: points,
        isLoading: isLoading,
      ),
    );
  }
}
