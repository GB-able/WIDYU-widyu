part of '../my_page_screen.dart';

class _HeaderContent extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final int? points;
  final bool isLoading;

  const _HeaderContent({
    required this.profileImage,
    required this.name,
    required this.points,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileView(
          isLoading: isLoading,
          profileImage: profileImage,
          name: name,
        ),
        const SizedBox(height: 20),
        _PointView(
          isLoading: isLoading,
          points: points,
        ),
      ],
    );
  }
}
