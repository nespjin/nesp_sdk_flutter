// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_ui/src/screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller = WebViewController()
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: _onPageFinished,
        // onNavigationRequest: _onNavigationRequest,
        onWebResourceError: _onWebResourceError,
      ),
    )
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.loadRequest(Uri.parse(widget.url));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen.withTitle(
      widget.title,
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }

  void _onPageFinished(String url) {}

  // FutureOr<NavigationDecision> _onNavigationRequest(
  //     NavigationRequest request) async {
  //   return NavigationDelegate.fromPlatform();
  // }

  void _onWebResourceError(WebResourceError error) {
    if (error.errorType == WebResourceErrorType.hostLookup) {
      // Network Error
      // TODO: Display the network error page
    }
    // debugPrint('>>>>>>>>>>>>>>>${error.errorType?.name}');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
