import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  const DashLine({
    super.key,
    this.axis = Axis.horizontal,
    this.dashWidth = 3.0,
    this.dashHeight = 1.0,
  });

  final Axis axis;
  final double dashWidth;
  final double dashHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: axis,
        children: List.generate(dashCount, (_) {
          return Container(
            width: dashWidth,
            height: dashHeight,
            color: const Color(0xFFE5E5E5),
          );
        }),
      );
    });
  }
}
