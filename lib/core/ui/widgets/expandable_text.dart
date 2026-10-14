import 'package:flutter/material.dart';

class ExpandableText extends StatelessWidget {
  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    required this.moreStyle,
    this.maxLines = 2,
    this.isExpanded = false,
    this.onExpandChanged,
    this.moreLabel = "더보기",
    this.lessLabel = "접기",
  });

  final String text;
  final TextStyle style;
  final TextStyle moreStyle;
  final int maxLines;
  final bool isExpanded;
  final ValueChanged<bool>? onExpandChanged;
  final String moreLabel;
  final String lessLabel;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);

        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: style,
              maxLines: isExpanded ? null : maxLines,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (overflows)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onExpandChanged?.call(!isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(isExpanded ? lessLabel : moreLabel, style: moreStyle),
                ),
              ),
          ],
        );
      },
    );
  }
}
