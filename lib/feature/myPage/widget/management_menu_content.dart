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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(asset, width: 24, height: 24),
          const SizedBox(width: 8),
          Expanded(
            child: _TextMenu(
              title: title,
              onClick: onClick,
            ),
          ),
        ],
      ),
    );
  }
}
