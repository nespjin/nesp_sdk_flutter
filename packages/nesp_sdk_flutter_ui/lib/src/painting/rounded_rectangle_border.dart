import 'package:flutter/material.dart';

class TriangleRoundedRectangleBorder extends RoundedRectangleBorder {
  const TriangleRoundedRectangleBorder({
    super.side,
    super.borderRadius,
  });

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    super.paint(canvas, rect, textDirection: textDirection);
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final RRect outer = borderRadius.resolve(textDirection).toRRect(rect);
        final Paint paint = Paint()..color = side.color;

        // Draw the shadow.
        canvas.drawRRect(
            outer,
            Paint()
              ..color = const Color(0x29000000).withOpacity(0.3)
              ..isAntiAlias = true
              ..strokeCap = StrokeCap.round
              ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2.0));

        // Draw the triangle.
        Path path = Path();
        path
          ..moveTo(75, 0)
          ..lineTo(88, -7)
          ..lineTo(90, -8)
          ..lineTo(92, -7)
          ..lineTo(100, 0)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }
}
