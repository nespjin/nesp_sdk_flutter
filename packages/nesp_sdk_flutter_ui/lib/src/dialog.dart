// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nesp_sdk_flutter_ui/src/l10n/strings.dart';
import 'package:nesp_sdk_flutter_ui/src/text.dart';

const _kBoxConstraints = BoxConstraints(
  minHeight: 150,
  maxHeight: 400,
  minWidth: 300,
  maxWidth: 300,
);

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  Duration? insetAnimationDuration,
  Curve? insetAnimationCurve,
  EdgeInsets? insetPadding,
  Clip? clipBehavior,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool barrierDismissible = true,
  bool backPressedDismissible = true,
  PopInvokedCallback? onPopInvoked,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showDialog(
    context: context,
    builder: (context) => PopScope(
      onPopInvoked: onPopInvoked,
      canPop: backPressedDismissible,
      child: Dialog(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: elevation,
        insetAnimationDuration:
            insetAnimationDuration ?? const Duration(milliseconds: 100),
        insetAnimationCurve: insetAnimationCurve ?? Curves.decelerate,
        insetPadding: insetPadding ??
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        clipBehavior: Clip.none,
        shape: shape,
        alignment: alignment,
        child: builder(context),
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

Future<T?> showBlurAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  Duration? insetAnimationDuration,
  Curve? insetAnimationCurve,
  EdgeInsets? insetPadding,
  Clip? clipBehavior,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool barrierDismissible = true,
  bool backPressedDismissible = true,
  // Color? barrierColor = Colors.black54,
  String? barrierLabel,
  // bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, _, __) => PopScope(
      canPop: backPressedDismissible,
      child: Dialog(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: elevation,
        insetAnimationDuration:
            insetAnimationDuration ?? const Duration(milliseconds: 100),
        insetAnimationCurve: insetAnimationCurve ?? Curves.decelerate,
        insetPadding: insetPadding ??
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        clipBehavior: Clip.none,
        shape: shape,
        alignment: alignment,
        child: builder(context),
      ),
    ),
    transitionBuilder: (ctx, anim1, anim2, child) {
      return BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 5 * anim1.value, sigmaY: 5 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
    barrierDismissible: barrierDismissible,
    // barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    // useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

Future<T?> showAppCupertinoDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  Duration? insetAnimationDuration,
  Curve? insetAnimationCurve,
  EdgeInsets? insetPadding,
  Clip? clipBehavior,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool barrierDismissible = true,
  bool backPressedDismissible = true,
  PopInvokedCallback? popInvoked,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => PopScope(
      onPopInvoked: popInvoked,
      canPop: backPressedDismissible,
      child: Dialog(
        backgroundColor: backgroundColor ?? Colors.transparent,
        elevation: elevation,
        insetAnimationDuration:
            insetAnimationDuration ?? const Duration(milliseconds: 100),
        insetAnimationCurve: insetAnimationCurve ?? Curves.decelerate,
        insetPadding: insetPadding ??
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        clipBehavior: Clip.none,
        shape: shape,
        alignment: alignment,
        child: builder(context),
      ),
    ),
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    super.key,
    this.title,
    required this.message,
    this.maxLines,
    this.messageStyle,
    this.overflow,
    required this.actions,
  });

  final String? title;
  final String message;
  final int? maxLines;
  final TextStyle? messageStyle;
  final TextOverflow? overflow;
  final List<DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: title != null ? AppDialogTitle(text: title!) : null,
      actions: actions,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text2(
          message,
          style: messageStyle ?? Theme.of(context).textTheme.bodyMedium,
          softWrap: true,
          maxLines: maxLines ?? 5,
          overflow: overflow ?? TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// A dialog wrapper for [TextField]
class TextEditorDialog extends StatefulWidget {
  const TextEditorDialog({
    super.key,
    required this.title,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = true,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.readOnly = false,
    this.negativeText,
    this.positiveText,
    this.onNegativeTap,
    this.onPositiveTap,
    this.isDismissWhenActionClicked = true,
    this.onDismiss,
  });

  final String title;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool readOnly;
  final String? negativeText;
  final String? positiveText;
  final GestureTapCallback? onNegativeTap;
  final GestureTapCallback? onPositiveTap;
  final bool isDismissWhenActionClicked;
  final VoidCallback? onDismiss;

  @override
  State<TextEditorDialog> createState() => _TextEditorDialogState();
}

class _TextEditorDialogState extends State<TextEditorDialog> {
  // static const double _clearButtonSize = 18.0;

  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: widget.title.isEmpty
          ? null
          : AppDialogTitle(
              text: widget.title,
              maxLines: 3,
            ),
      actions: [
        DialogAction.negative(
          text: widget.negativeText ?? Strings.of(context).cancel,
          onTap: widget.onNegativeTap,
        ),
        DialogAction.positive(
          text: widget.positiveText ?? Strings.of(context).confirm,
          onTap: widget.onPositiveTap,
        ),
      ],
      isDismissWhenActionClicked: widget.isDismissWhenActionClicked,
      child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8),
          child: CupertinoTextField(
            decoration: const BoxDecoration(),
            clearButtonMode: OverlayVisibilityMode.editing,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            autofocus: widget.autoFocus,
            controller: _controller,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled ?? true,
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() {});
            },
            readOnly: widget.readOnly,
          )
          // TextField(
          //    decoration: InputDecoration(
          //      border: InputBorder.none,
          //      hintText: widget.hintText,
          //      suffixIcon: _controller.text.isEmpty
          //          ? null
          //          : InkWell(
          //              onTap: () {
          //                _controller.clear();
          //                setState(() {});
          //              },
          //              child: const Icon(
          //                size: _clearButtonSize,
          //                CupertinoIcons.clear_circled_solid,
          //                color: CupertinoColors.systemGrey4,
          //              ),
          //            ),
          //    ),
          //    maxLines: widget.maxLines,
          //    maxLength: widget.maxLength,
          //    keyboardType: widget.keyboardType,
          //    textInputAction: widget.textInputAction,
          //    obscureText: widget.obscureText,
          //    autofocus: widget.autoFocus,
          //    controller: _controller,
          //    onEditingComplete: widget.onEditingComplete,
          //    onSubmitted: widget.onSubmitted,
          //    inputFormatters: widget.inputFormatters,
          //    enabled: widget.enabled,
          //    onChanged: (value) {
          //      widget.onChanged?.call(value);
          //      setState(() {});
          //    },
          //    readOnly: widget.readOnly,
          //  ),
          ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    widget.onDismiss?.call();
    super.dispose();
  }
}

class AppDialogTitle extends StatelessWidget {
  const AppDialogTitle({
    super.key,
    required this.text,
    this.maxLines = 1,
  });

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 17,
        color: Color(0xFF333333),
      ),
    );
  }
}

/// The common base app alert dialog which is similar with the [AlertDialog].
class AppAlertDialog extends StatefulWidget {
  const AppAlertDialog({
    super.key,
    this.contentPadding,
    this.title,
    this.subtitle,
    required this.child,
    required this.actions,
    this.width,
    this.height,
    this.constraints,
    this.decoration,
    this.isDismissWhenActionClicked = true,
  });

  final EdgeInsets? contentPadding;
  final Widget? title;
  final Widget? subtitle;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;
  final Widget child;
  final bool isDismissWhenActionClicked;
  final List<DialogAction> actions;

  @override
  State<AppAlertDialog> createState() => _AppAlertDialogState();
}

class _AppAlertDialogState extends State<AppAlertDialog> {
  late List<DialogAction> actions = [];

  @override
  void initState() {
    super.initState();
    if (widget.isDismissWhenActionClicked) {
      _setDismissWhenActionClicked();
    }
  }

  void _setDismissWhenActionClicked() {
    final oldActions = widget.actions;
    for (int i = 0; i < oldActions.length; i++) {
      final oldAction = oldActions[i];
      actions.add(oldAction.copyWith(
        onTap: () {
          Navigator.maybePop(context);
          oldAction.onTap?.call();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration ??
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        );

    var constraints = widget.constraints;
    if (widget.width == null && widget.height == null && constraints == null) {
      constraints = _kBoxConstraints;
    }
    return Container(
      width: widget.width,
      height: widget.height,
      constraints: constraints,
      decoration: decoration,
      child: Padding(
        padding: widget.contentPadding ?? const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) widget.title!,
                if (widget.title != null && widget.subtitle != null)
                  const SizedBox(height: 8),
                if (widget.subtitle != null) widget.subtitle!,
                Padding(
                  padding: EdgeInsets.only(
                    top: (widget.title != null || widget.subtitle != null)
                        ? 8.0
                        : 0.0,
                    bottom: actions.isNotEmpty ? 16.0 : 0.0,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 60),
                    child: Center(
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),

            // If there is little actions, will layout them horizontally.
            if (actions.length < 3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.map((e) {
                  final index = actions.indexOf(e);
                  EdgeInsets padding = EdgeInsets.zero;
                  if (actions.length > 1) {
                    // Gap width is 16.0 between the actions.
                    const gapWidth = 16;
                    if (index == 0) {
                      padding = const EdgeInsets.only(right: gapWidth / 2);
                    } else if (index == actions.length - 1) {
                      padding = const EdgeInsets.only(left: gapWidth / 2);
                    } else {
                      padding =
                          const EdgeInsets.symmetric(horizontal: gapWidth / 2);
                    }
                  }

                  return Expanded(child: Padding(padding: padding, child: e));
                }).toList(),
              ),

            // If there is many actions, will layout them vertically.
            if (actions.length >= 3)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions.map((e) {
                  final index = actions.indexOf(e);
                  EdgeInsets padding = EdgeInsets.zero;
                  // Gap width is 8.0 between the actions.
                  const gapWidth = 8;
                  if (index == 0) {
                    padding = const EdgeInsets.only(bottom: gapWidth / 2);
                  } else if (index == actions.length - 1) {
                    padding = const EdgeInsets.only(top: gapWidth / 2);
                  } else {
                    padding =
                        const EdgeInsets.symmetric(vertical: gapWidth / 2);
                  }
                  return Padding(padding: padding, child: e);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class DialogAction extends StatelessWidget {
  const DialogAction({
    super.key,
    required this.type,
    required this.text,
    this.height = _kDefaultHeight,
    this.borderRadius,
    this.onTap,
    this.textSize = _kDefaultTextSize,
    this.backgroundColor,
    this.textColor,
  });

  const DialogAction.positive({
    super.key,
    required this.text,
    this.height = _kDefaultHeight,
    this.borderRadius,
    this.onTap,
    this.textSize = _kDefaultTextSize,
    this.backgroundColor,
    this.textColor,
  }) : type = typePositive;

  const DialogAction.negative({
    super.key,
    required this.text,
    this.height = _kDefaultHeight,
    this.borderRadius,
    this.onTap,
    this.textSize = _kDefaultTextSize,
    this.backgroundColor,
    this.textColor,
  }) : type = typeNegative;

  const DialogAction.danger({
    super.key,
    required this.text,
    this.height = _kDefaultHeight,
    this.borderRadius,
    this.onTap,
    this.textSize = _kDefaultTextSize,
    this.backgroundColor,
    this.textColor,
  }) : type = typeDanger;

  static const double _kDefaultHeight = 45;
  static const double _kDefaultTextSize = 16;

  static const int typePositive = 0;
  static const int typeNegative = 1;
  static const int typeDanger = 2;

  final int type;
  final String text;
  final double height;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;
  final double textSize;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = this.backgroundColor;
    var textColor = this.textColor;
    if (type == typeNegative) {
      backgroundColor ??= const Color(0xFFEFEFEF);
      textColor ??= const Color(0xFF333333);
    } else if (type == typePositive) {
      backgroundColor ??= const Color(0xFF509EF0);
      textColor ??= Colors.white;
    } else if (type == typeDanger) {
      backgroundColor ??= const Color(0xFFF54337);
      textColor ??= Colors.white;
    }

    final borderRadius = this.borderRadius ?? BorderRadius.circular(height / 2);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text2(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }

  DialogAction copyWith({
    int? type,
    String? text,
    double? height,
    BorderRadius? borderRadius,
    GestureTapCallback? onTap,
    double? textSize,
  }) =>
      DialogAction(
        type: type ?? this.type,
        text: text ?? this.text,
        height: height ?? this.height,
        borderRadius: borderRadius ?? this.borderRadius,
        onTap: onTap ?? this.onTap,
        textSize: textSize ?? this.textSize,
      );
}
