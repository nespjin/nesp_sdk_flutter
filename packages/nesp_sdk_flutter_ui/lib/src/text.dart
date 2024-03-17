import 'package:flutter/material.dart';

///
/// Author: <a href="mailto:dyjinzl@chint.com">JinZhaolu</a>
/// Time: Created 2022/12/22 下午12:39
/// Description:
///

class Text2 extends Text {
  Text2(
    String data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super(_wrapText(data));

  const Text2.rich(
    super.textSpan, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  static String _wrapText(String word) {
    if (word.isEmpty) {
      return word;
    }
    String ret = ' ';
    for (final char in word.runes) {
      ret += String.fromCharCode(char);
      ret += '\u200B';
    }
    return ret;
  }
}
