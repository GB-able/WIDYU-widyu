part of '../my_page_screen.dart';

class _HeaderContent extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final bool isLoading;
  final int? point;
  final bool isPointLoading;
  final Future<void> Function() onProfileClosed;

  const _HeaderContent({
    required this.profileImage,
    required this.name,
    required this.isLoading,
    required this.point,
    required this.isPointLoading,
    required this.onProfileClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileView(
          isLoading: isLoading,
          profileImage: profileImage,
          name: name,
          onProfileClosed: onProfileClosed,
        ),
        const SizedBox(height: 20),
        _PointView(point: point, isPointLoading: isPointLoading),
      ],
    );
  }
}
