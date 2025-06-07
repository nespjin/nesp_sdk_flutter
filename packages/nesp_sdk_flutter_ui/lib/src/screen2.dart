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
    this.secondaryTabs,
    this.tabViewPadding = EdgeInsets.zero,
    this.leading,
    this.onLeadingTap,
    this.tailing,
    this.onTailingTap,
    this.resizeToAvoidBottomInset,
    this.backgroundColor = const Color(0xFFF8F8F8),
    this.title,
    this.actions,
    this.body,
    this.useSafeArea = true,
    this.backgroundGradient,
    this.appBarBackgroundColor = const Color(0xFFD0E6FC),
    this.appBarElevation = 0.2,
    this.systemOverlayStyle = defaultScreenSystemUiOverlayStyle,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  factory Screen.withTitle(
    String title, {
    Key? key,
    List<Tab>? secondaryTabs,
    EdgeInsets tabViewPadding = EdgeInsets.zero,
    SystemUiOverlayStyle? systemOverlayStyle =
        defaultScreenSystemUiOverlayStyle,
    EdgeInsets padding = EdgeInsets.zero,
    Widget? leading,
    Widget? tailing,
    GestureTapCallback? onTailingTap,
    Color backgroundColor = const Color(0xFFF8F8F8),
    bool? resizeToAvoidBottomInset,
    GestureTapCallback? onLeadingTap,
    List<Widget>? actions,
    Widget? body,
    Gradient? backgroundGradient,
    Color? appBarBackgroundColor = const Color(0xFFD0E6FC),
    double? appBarElevation = 0,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) {
    return Screen(
      key: key,
      secondaryTabs: secondaryTabs,
      tabViewPadding: tabViewPadding,
      systemOverlayStyle: systemOverlayStyle,
      padding: padding,
      leading: leading,
      tailing: tailing,
      onTailingTap: onTailingTap,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      onLeadingTap: onLeadingTap,
      title: ScreenTitle(title: title),
      actions: actions,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      backgroundGradient: backgroundGradient,
      appBarBackgroundColor: appBarBackgroundColor,
      appBarElevation: appBarElevation,
    );
  }

  final EdgeInsets padding;
  final Widget? leading;
  final GestureTapCallback? onLeadingTap;
  final Widget? tailing;
  final GestureTapCallback? onTailingTap;
  final Color backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// 用来判断是否需要内容在导航栏以下
  final bool useSafeArea;
  final Gradient? backgroundGradient;
  final Color? appBarBackgroundColor;
  final double? appBarElevation;
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Secondary tabs under the app bar.
  ///
  /// If `secondaryTabs` is not null, will display a tab bar below the app bar,
  /// and the body will be displayed under it as `TabBarView`.
  final List<Tab>? secondaryTabs;
  final EdgeInsets tabViewPadding;

  @override
  Widget build(BuildContext context) {
    var body = this.body;

    final secondaryTabs = this.secondaryTabs;
    if (secondaryTabs != null && secondaryTabs.isNotEmpty) {
      body = DefaultTabController(
        length: secondaryTabs.length,
        child: Column(
          children: [
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            Container(
              height: 42,
              color: Colors.white,
              child: TabBar.secondary(
                dividerHeight: 1,
                dividerColor: Colors.black,
                tabs: secondaryTabs,
                labelStyle: const TextStyle(
                  color: Color(0xFF509FF1),
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            if (body != null)
              Expanded(
                child: Padding(
                  padding: tabViewPadding,
                  child: body,
                ),
              ),
          ],
        ),
      );
    }

    body = Padding(padding: padding, child: body);
    if (useSafeArea) {
      body = SafeArea(child: body);
    }

    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: systemOverlayStyle,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leading ?? _buildDefaultLeading(context),
                    ...actions ?? [const SizedBox.shrink()],
                    if (tailing != null)
                      if (onTailingTap != null)
                        GestureDetector(
                          onTap: onTailingTap!,
                          child: tailing!,
                        )
                      else
                        tailing!,
                  ],
                ),
              ),
              Center(child: title ?? const SizedBox.shrink()),
            ],
          ),
          toolbarHeight: kMinInteractiveDimension,
          elevation: appBarElevation,
          backgroundColor: Colors.transparent,
          flexibleSpace: _buildAppBarFlexibleSpace(),
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        body: Stack(
          children: [
            _buildScreenBackgroundGradient(),
            body,
          ],
        ),
      ),
    );
  }

  GestureDetector _buildDefaultLeading(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onLeadingTap == null) {
          Navigator.maybePop(context);
        } else {
          onLeadingTap?.call();
        }
      },
      child: const SizedBox(
        height: kToolbarHeight,
        width: kMinInteractiveDimension,
        child: ScreenBackIcon(),
      ),
    );
  }

  Widget _buildScreenBackgroundGradient() {
    if (backgroundGradient == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
    );
  }

  Widget? _buildAppBarFlexibleSpace() {
    if (appBarBackgroundColor == null) {
      return null;
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appBarBackgroundColor!,
            backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
