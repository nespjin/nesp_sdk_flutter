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
