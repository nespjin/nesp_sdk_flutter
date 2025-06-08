// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:nesp_sdk_flutter_social/nesp_sdk_flutter_social.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('getPlatformVersion test', (WidgetTester tester) async {
  //   final NespSdkFlutterSocial plugin = NespSdkFlutterSocial();
  //   final String? version = await plugin.getPlatformVersion();
  // The version string depends on the host platform running the test, so
  // just assert that some non-empty string is returned.
  //   expect(version?.isNotEmpty, true);
  // });
}
