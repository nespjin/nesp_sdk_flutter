import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nesp_sdk_dart_math/nesp_sdk_dart_math.dart';

class TriangleBorder extends Border {
  const TriangleBorder({
    super.top = BorderSide.none,
    super.right = BorderSide.none,
    super.bottom = BorderSide.none,
    super.left = BorderSide.none,
    required this.triangleColor,
    this.triangleAlignment = Alignment.bottomRight,
    this.triangleOffset = Offset.zero,
  });

  factory TriangleBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    double strokeAlign = BorderSide.strokeAlignInside,
    Color triangleColor = const Color(0xFF000000),
  }) {
    final BorderSide side = BorderSide(
        color: color, width: width, style: style, strokeAlign: strokeAlign);
    return TriangleBorder.fromBorderSide(side, triangleColor);
  }

  static fromBorderSide(BorderSide side, Color triangleColor) => TriangleBorder(
        top: side,
        right: side,
        bottom: side,
        left: side,
        triangleColor: triangleColor,
      );

  final Color triangleColor;
  final Alignment triangleAlignment;
  final Offset triangleOffset;

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius? borderRadius}) {
    super.paint(canvas, rect,
        textDirection: textDirection, shape: shape, borderRadius: borderRadius);

    if (shape == BoxShape.rectangle &&
        super.bottom.style == BorderStyle.solid) {
      _paintTriangle(canvas, rect);
    }
  }

  void _paintTriangle(Canvas canvas, Rect rect) {
    var leftPoint = Point<double>(rect.left, rect.bottom);

    const sidewaysLength = 10.0;
    const bottomSideLength = 10.0;

    final triangle =
        Triangle<double>.isosceles(leftPoint, sidewaysLength, bottomSideLength)
            .flipVertically();

    if (triangleAlignment == Alignment.centerLeft) {}

    final path = Path()
      ..moveTo(triangle.leftPoint.x, triangle.leftPoint.y)
      ..lineTo(triangle.topPoint.x, triangle.topPoint.y)
      ..lineTo(triangle.rightPoint.x, triangle.rightPoint.y)
      ..close();

    final bottom = super.bottom;

    final Paint paint = Paint()
      ..strokeWidth = bottom.width
      ..color = bottom.color
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);

    paint.color = triangleColor;
    paint.style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    path.reset();
    path
      ..moveTo(triangle.leftPoint.x, triangle.leftPoint.y)
      ..lineTo(triangle.rightPoint.x, triangle.rightPoint.y)
      ..close();

    paint.strokeWidth = bottom.width * 2;
    paint.style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }
}
