// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_ui/src/styles.dart';

class DangerRoundOutlineButton extends StatelessWidget {
  const DangerRoundOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: style ??
          defaultDangerRoundCornerOutlineButtonStyle.copyWith(
            fixedSize: ButtonStyleButton.allOrNull(
              const Size(155, 44),
            ),
          ),
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
              fontSize: 16,
              color: Color(0xFFF54337),
            ),
      ),
    );
  }
}
