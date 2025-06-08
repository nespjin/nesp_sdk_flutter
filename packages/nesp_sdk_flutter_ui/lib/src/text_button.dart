// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';

class TextButton2 extends StatefulWidget {
  const TextButton2({
    super.key,
    required this.text,
    this.style = const TextStyle(
      color: Color(0xFF519FF1),
      fontSize: 17,
    ),
    this.disabled = false,
    this.onTap,
  });

  final String text;
  final TextStyle style;
  final bool disabled;
  final GestureTapCallback? onTap;

  @override
  State<TextButton2> createState() => _TextButton2State();
}

class _TextButton2State extends State<TextButton2> {
  double _opacity = 1;
  @override
  Widget build(BuildContext context) {
    if (widget.disabled) {
      _opacity = 0.7;
    }
    return GestureDetector(
      onTap: widget.disabled ? null : widget.onTap,
      onTapDown: (details) {
        _effectOpacity();
      },
      onTapUp: (details) {
        _resetOpacity();
      },
      onVerticalDragDown: (details) {
        _effectOpacity();
      },
      onVerticalDragEnd: (details) {
        _resetOpacity();
      },
      onHorizontalDragDown: (details) {
        _effectOpacity();
      },
      onHorizontalDragEnd: (details) {
        _resetOpacity();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: _opacity,
          child: Text(
            widget.text,
            style: widget.style,
          ),
        ),
      ),
    );
  }

  void _effectOpacity() {
    setState(() {
      _opacity = 0.7;
    });
  }

  void _resetOpacity() {
    setState(() {
      _opacity = 1;
    });
  }
}
