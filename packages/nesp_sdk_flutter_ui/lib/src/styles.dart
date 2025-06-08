// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

///
/// Defines the app themes, uses Material Design3.
/// Material Design3 Reference: https://m3.material.io/
/// Material Design Reference: https://material.io/
///

class NoSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create(
      {required MaterialInkController controller,
      required RenderBox referenceBox,
      required Offset position,
      required Color color,
      required TextDirection textDirection,
      bool containedInkWell = false,
      RectCallback? rectCallback,
      BorderRadius? borderRadius,
      ShapeBorder? customBorder,
      double? radius,
      VoidCallback? onRemoved}) {
    return _NoSplashFactoryInteractiveInkFeature(
        controller: controller, referenceBox: referenceBox, color: color);
  }
}

class _NoSplashFactoryInteractiveInkFeature extends InteractiveInkFeature {
  _NoSplashFactoryInteractiveInkFeature(
      {required super.controller,
      required super.referenceBox,
      required super.color});

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}

const defaultPopMenuTextStyle = TextStyle(fontSize: 15, color: Colors.white);

final defaultRoundCornerElevatedButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  elevation: 0,
  side: const BorderSide(color: Color(0xFF0174ED), width: 0.5),
  backgroundColor: const Color(0xFF519FF1),
);

final defaultDangerRoundCornerElevatedButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  elevation: 0,
  side: const BorderSide(color: Color(0xFFD4D4D4), width: 0.5),
  backgroundColor: Colors.white,
  textStyle: const TextStyle(
    fontSize: 16,
    color: Color(0xFFF54337),
  ),
);

final defaultDangerRoundCornerOutlineButtonStyle = OutlinedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  side: const BorderSide(color: Color(0xFFD4D4D4), width: 0.5),
  splashFactory: NoSplashFactory(),
  backgroundColor: Colors.white,
  textStyle: const TextStyle(
    fontSize: 16,
    color: Color(0xFFF54337),
  ),
);
