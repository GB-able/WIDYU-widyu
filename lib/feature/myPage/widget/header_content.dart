part of '../my_page_screen.dart';

class _HeaderContent extends StatelessWidget {
  final String? profileImage;
  final String name;
  final int points;
  final bool isLoading;
  final bool isError;

  const _HeaderContent({
    super.key,
    this.profileImage,
    required this.name,
    required this.points,
    this.isLoading = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileView(
          isLoading: isLoading,
          profileImage: profileImage,
          name: isError ? null : name,
        ),
        const SizedBox(height: 20),
        _PointView(
          isLoading: isLoading,
          points: isError ? null : points,
        ),
      ],
    );
  }
}
