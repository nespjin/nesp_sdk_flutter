// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

abstract class ObservableUiComponentDelegate with WidgetsBindingObserver {
  ObservableUiComponentDelegate();

  // StreamSubscription? _connectivityStreamSubscription;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  bool _isNetworkAvailable = false;

  bool get isNetworkAvailable => _isNetworkAvailable;

  @mustCallSuper
  void onConnectivityChanged(ConnectivityResult result) {
    _connectivityResult = result;
    final oldIsNetworkAvailable = _isNetworkAvailable;
    _isNetworkAvailable = result != ConnectivityResult.none;

    if (oldIsNetworkAvailable != _isNetworkAvailable) {
      onNetworkAvailableChanged(_isNetworkAvailable);
    }
  }

  @mustCallSuper
  void onNetworkAvailableChanged(bool isNetworkAvailable) {}
}
