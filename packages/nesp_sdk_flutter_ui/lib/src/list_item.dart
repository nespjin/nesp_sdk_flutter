import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    this.leadingImage,
    required this.title,
    this.titleMaxLines = 1,
    this.titleStyle = const TextStyle(
      fontSize: 17,
      color: Color(0xFF333333),
    ),
    this.value = '',
    this.valueMaxLines = 1,
    this.valueStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF074188),
    ),
    this.showTailingArrow = true,
    this.showBottomDividerLine = false,
    this.showTopDividerLine = false,
    this.topDividerLineIndent = 16,
    this.bottomDividerLineIndent = 16,
    this.height = 60,
    this.onTap,
  });

  final Image? leadingImage;

  final String title;
  final int titleMaxLines;
  final TextStyle titleStyle;

  final String value;
  final int valueMaxLines;
  final TextStyle valueStyle;
  final bool showTailingArrow;

  final bool showTopDividerLine;
  final bool showBottomDividerLine;
  final double? topDividerLineIndent;
  final double? bottomDividerLineIndent;
  final double? height;

  final ValueChanged<ListItem>? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(this);
        }
      },
      child: Container(
        height: height,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 8),
              constraints: const BoxConstraints(minHeight: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (leadingImage != null) ...[
                    Image(
                      image: leadingImage!.image,
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        maxLines: valueMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: valueStyle,
                      ),
                      const SizedBox(width: 8),
                      if (showTailingArrow)
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xFFC7C7CC),
                          size: 24,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (showTopDividerLine)
              Align(
                alignment: Alignment.topCenter,
                child: _buildDivider(topDividerLineIndent),
              ),
            if (showBottomDividerLine)
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildDivider(bottomDividerLineIndent),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double? indent) {
    return Divider(
      indent: indent,
      color: const Color(0xFFE5E5E5),
      height: 0.5,
    );
  }
}
