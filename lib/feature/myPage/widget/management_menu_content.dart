part of '../my_page_screen.dart';

class _ManagementMenuContent extends StatelessWidget {
  final String asset;
  final String title;
  final VoidCallback onClick;

  const _ManagementMenuContent({
    required this.asset,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: _TextMenu(
        asset: asset,
        title: title,
        onClick: onClick,
      ),
    );
  }
}
