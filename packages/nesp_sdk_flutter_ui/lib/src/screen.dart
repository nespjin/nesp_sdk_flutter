import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ScreenBackIcon extends StatelessWidget {
  const ScreenBackIcon({
    super.key,
    this.color = Colors.black,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_back_ios,
      color: color,
      size: 22,
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key, required this.title, this.color});

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.titleLarge;
    if (color != null) {
      style = style?.copyWith(color: color);
    }
    return Text(
      title,
      style: style,
    );
  }
}

const defaultScreenSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.dark,
);

class Screen extends StatelessWidget {
  const Screen({
    super.key,
    this.padding = EdgeInsets.zero,
    this.leading = const ScreenBackIcon(),
    this.resizeToAvoidBottomInset,
    this.backgroundColor = const Color(0xFFF8F8F8),
    this.onLeadingTap,
    this.title,
    this.actions,
    this.body,
    this.backGradient,
    this.appBarTransparent = true,
    this.appBarElevation = true,
    this.systemOverlayStyle = defaultScreenSystemUiOverlayStyle,
  });

  factory Screen.withTitle(
    String title, {
    Key? key,
    SystemUiOverlayStyle? systemOverlayStyle =
        defaultScreenSystemUiOverlayStyle,
    EdgeInsets padding = EdgeInsets.zero,
    Widget? leading,
    Color backgroundColor = const Color(0xFFF8F8F8),
    bool? resizeToAvoidBottomInset,
    GestureTapCallback? onLeadingTap,
    List<Widget>? actions,
    Widget? body,
    Gradient? backGradient,
    bool appBarTransparent = false,
    bool appBarElevation = true,
  }) {
    return Screen(
      key: key,
      systemOverlayStyle: systemOverlayStyle,
      padding: padding,
      leading: leading,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      onLeadingTap: onLeadingTap,
      title: ScreenTitle(title: title),
      actions: actions,
      body: body,
      backGradient: backGradient,
      appBarTransparent: appBarTransparent,
      appBarElevation: appBarElevation,
    );
  }

  final EdgeInsets padding;
  final Widget? leading;
  final Color backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final GestureTapCallback? onLeadingTap;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? body;
  final Gradient? backGradient;
  final bool appBarTransparent;
  final bool appBarElevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: systemOverlayStyle?.copyWith(
            systemNavigationBarColor: backgroundColor,
          ),
          centerTitle: true,
          title: title,
          toolbarHeight: kMinInteractiveDimension,
          leading: leading != null
              ? leading!
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (onLeadingTap == null) {
                      Navigator.maybePop(context);
                    } else {
                      onLeadingTap?.call();
                    }
                  },
                  child: const ScreenBackIcon(),
                ),
          actions: actions,
          elevation: appBarElevation ? 0.2 : 0,
          backgroundColor: const Color(0x00FFFFFF),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: appBarTransparent ? const Color(0x00FFFFFF) : null,
              gradient: !appBarTransparent
                  ? LinearGradient(
                      colors: [
                        const Color(0xFFD0E6FC),
                        backgroundColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: backGradient),
            ),
            SafeArea(
              child: Padding(
                padding: padding,
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
