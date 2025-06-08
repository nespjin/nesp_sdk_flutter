// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nesp_sdk_flutter_social_method_channel.dart';

abstract class NespSdkFlutterSocialPlatform extends PlatformInterface {
  /// Constructs a NespSdkFlutterSocialPlatform.
  NespSdkFlutterSocialPlatform() : super(token: _token);

  static final Object _token = Object();

  static NespSdkFlutterSocialPlatform _instance =
      MethodChannelNespSdkFlutterSocial();

  /// The default instance of [NespSdkFlutterSocialPlatform] to use.
  ///
  /// Defaults to [MethodChannelNespSdkFlutterSocial].
  static NespSdkFlutterSocialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NespSdkFlutterSocialPlatform] when
  /// they register themselves.
  static set instance(NespSdkFlutterSocialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> joinQQGroup({
    String androidKey = '',
    String iosKey = '',
    required String groupUin,
  }) {
    throw UnimplementedError('joinQQGroup() has not been implemented.');
  }

  Future<bool> joinQQFriend({required String qqFriendNumber}) {
    throw UnimplementedError('joinQQFriend() has not been implemented.');
  }

  Future<bool> openWeiboUser({required String uid}) {
    throw UnimplementedError('openWeiboUser() has not been implemented.');
  }

  Future<bool> openOtherApp({
    String androidPackageName = '',
    String androidClassName = '',
    String iosAppUrl = '',
  }) {
    throw UnimplementedError('openOtherApp() has not been implemented.');
  }
}
