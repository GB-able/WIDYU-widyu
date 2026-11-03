import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';

class CommentEditField extends StatelessWidget {
  const CommentEditField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: MyColor.grey300),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              groupId: CommentEditField,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmitted?.call(),
              style: MyTypo.body2.copyWith(color: MyColor.black),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: MyTypo.body2.copyWith(color: MyColor.grey600),
                contentPadding: EdgeInsets.zero,
                isDense: true,
                border: InputBorder.none,
              ),
            ),
          ),
          TapRegion(
            groupId: CommentEditField,
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, __) {
                final enabled = value.text.trim().isNotEmpty;
                return GestureDetector(
                  onTap: enabled ? onSubmitted : null,
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    '완료',
                    style: MyTypo.subTitle3.copyWith(
                      color: enabled ? MyColor.purple600 : MyColor.grey400,
                      letterSpacing: -0.28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
