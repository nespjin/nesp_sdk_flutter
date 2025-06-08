// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class RoundCornerButton extends StatefulWidget {
  const RoundCornerButton({
    super.key,
    required this.text,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 17,
    ),
    this.disabled = false,
    this.backgroundColor = const Color(0xFF519FF1),
    this.onTap,
    this.height = 45,
    this.width = 310,
    this.constraints,
  });

  final String text;
  final TextStyle style;
  final bool disabled;
  final Color backgroundColor;
  final double height;
  final double width;
  final BoxConstraints? constraints;
  final GestureTapCallback? onTap;

  @override
  State<RoundCornerButton> createState() => _RoundCornerButtonState();
}

class _RoundCornerButtonState extends State<RoundCornerButton> {
  double _opacity = 1;

  @override
  Widget build(Object context) {
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
      child: Opacity(
        opacity: _opacity,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          height: widget.height,
          width: widget.width,
          child: Center(
            child: Text(
              widget.text,
              style: widget.style,
            ),
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

class DangerRoundCornerButton extends StatelessWidget {
  const DangerRoundCornerButton({
    super.key,
    required this.text,
    this.disabled = false,
    this.height = 45,
    this.width = 310,
    this.backgroundColor = Colors.white,
    this.constraints,
    this.onTap,
  });

  final String text;
  final bool disabled;
  final Color backgroundColor;
  final double height;
  final double width;
  final BoxConstraints? constraints;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RoundCornerButton(
      text: text,
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFFF54337),
      ),
      disabled: disabled,
      backgroundColor: backgroundColor,
      height: height,
      width: width,
      constraints: constraints,
      onTap: onTap,
    );
  }
}
