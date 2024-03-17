import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastTime { short, long }

FutureOr<bool> showToast(
  String? message, {
  ToastTime? time,
  double? fontSize,
  Alignment? alignment,
  Color? textColor,
  Color? backgroundColor,
}) async {
  if (message == null || message.isEmpty) return false;

  Toast? toastLength;
  if (time != null) {
    if (time == ToastTime.short) {
      toastLength = Toast.LENGTH_SHORT;
    } else {
      toastLength = Toast.LENGTH_LONG;
    }
  }

  ToastGravity? toastGravity;
  if (alignment != null) {
    if (alignment == Alignment.topCenter) {
      toastGravity = ToastGravity.TOP;
    } else if (alignment == Alignment.topLeft) {
      toastGravity = ToastGravity.TOP_LEFT;
    } else if (alignment == Alignment.topRight) {
      toastGravity = ToastGravity.TOP_RIGHT;
    } else if (alignment == Alignment.center) {
      toastGravity = ToastGravity.CENTER;
    } else if (alignment == Alignment.centerLeft) {
      toastGravity = ToastGravity.CENTER_LEFT;
    } else if (alignment == Alignment.centerRight) {
      toastGravity = ToastGravity.CENTER_RIGHT;
    } else if (alignment == Alignment.bottomCenter) {
      toastGravity = ToastGravity.BOTTOM;
    } else if (alignment == Alignment.bottomLeft) {
      toastGravity = ToastGravity.BOTTOM_LEFT;
    } else if (alignment == Alignment.bottomRight) {
      toastGravity = ToastGravity.BOTTOM_RIGHT;
    }
  }

  return await Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        fontSize: fontSize,
        gravity: toastGravity,
        textColor: textColor,
        backgroundColor: backgroundColor,
      ) ??
      false;
}

FutureOr<bool> cancelToast() async {
  return await Fluttertoast.cancel() ?? false;
}
