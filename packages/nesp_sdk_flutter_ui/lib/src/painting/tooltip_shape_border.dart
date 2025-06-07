/*
 * Copyright (c) 2023. NESP Technology Corporation. All rights reserved.
 *
 * This program is not free software; you can't redistribute it and/or modify it
 * without the permit of team manager.
 *
 * Unless required by applicable law or agreed to in writing.
 *
 * If you have any questions or if you find a bug,
 * please contact the author by email or ask for Issues.
 */
import 'package:flutter/widgets.dart';

final class TooltipShape extends ShapeBorder {
  const TooltipShape({
    this.arrowAlignment = Alignment.topRight,
  });

  /// 箭头对齐方式
  ///
  /// 仅支持以下值：
  /// [Alignment.topRight] - 箭头在右上角
  /// [Alignment.topLeft] - 箭头在左上角
  final Alignment arrowAlignment;
  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.addRRect(_borderRadius.resolve(textDirection).toRRect(rect));
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    final baseX = rrect.left;
    final baseY = rrect.top;

    path.moveTo(baseX + 0, baseY + 10);
    path.quadraticBezierTo(baseX + 0, baseY + 0, baseX + 10, baseY + 0);

    if (arrowAlignment == Alignment.topRight) {
      path.lineTo(baseX + rrect.width - 30, baseY + 0);
      path.lineTo(baseX + rrect.width - 20, baseY + -10);
      path.lineTo(baseX + rrect.width - 10, baseY + 0);
    } else if (arrowAlignment == Alignment.topLeft) {
      path.lineTo(baseX + 20, baseY + -10);
      path.lineTo(baseX + 30, baseY + 0);
      path.lineTo(baseX + rrect.width - 10, baseY + 0);
    } else {
      throw Exception('Not support arrow alignment: $arrowAlignment');
    }

    path.quadraticBezierTo(
      baseX + rrect.width,
      baseY + 0,
      baseX + rrect.width,
      baseY + 10,
    );
    path.lineTo(
      baseX + rrect.width,
      baseY + rrect.height - 10,
    );
    path.quadraticBezierTo(
      baseX + rrect.width,
      baseY + rrect.height,
      baseX + rrect.width - 10,
      baseY + rrect.height,
    );
    path.lineTo(
      baseX + 10,
      baseY + rrect.height,
    );
    path.quadraticBezierTo(
      baseX + 0,
      baseY + rrect.height,
      baseX + 0,
      baseY + rrect.height - 10,
    );
    return path;
  }

  @override
  ShapeBorder scale(double t) {
    return RoundedRectangleBorder(
      side: _side.scale(t),
      borderRadius: _borderRadius * t,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
}
