import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class FeedMenuSheet extends StatelessWidget {
  const FeedMenuSheet({super.key, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Container(
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  if (onEdit != null) ...[
                    _MenuTile(
                      icon: WiduIcon(
                        icon: Assets.icons.ic18Edit,
                        width: 18,
                        color: MyColor.black,
                      ),
                      label: '수정하기',
                      color: MyColor.black,
                      onTap: () {
                        Navigator.pop(context);
                        onEdit?.call();
                      },
                    ),
                    const Divider(height: 1, color: MyColor.grey200),
                  ],
                  _MenuTile(
                    icon: WiduIcon(
                      icon: Assets.icons.ic18Delete,
                      width: 18,
                      color: MyColor.red,
                    ),
                    label: '삭제하기',
                    color: MyColor.red,
                    onTap: () {
                      Navigator.pop(context);
                      onDelete?.call();
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyColor.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '취소',
                  style: MyTypo.button.copyWith(color: MyColor.grey400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            icon,
            Text(label, style: MyTypo.button.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
