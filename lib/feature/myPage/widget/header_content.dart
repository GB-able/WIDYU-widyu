part of '../my_page_screen.dart';

class _HeaderContent extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final bool isLoading;
  final int? point;
  final bool isPointLoading;

  const _HeaderContent({
    required this.profileImage,
    required this.name,
    required this.isLoading,
    required this.point,
    required this.isPointLoading,
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
        _PointView(point: point, isPointLoading: isPointLoading),
      ],
    );
  }
}
