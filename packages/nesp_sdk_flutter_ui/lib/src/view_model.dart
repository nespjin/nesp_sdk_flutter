import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nesp_sdk_dart_core/nesp_sdk_dart_core.dart';
import 'package:nesp_sdk_flutter_ui/src/ui_state.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract base class ViewModel with WidgetsBindingObserver {
  ViewModel(
    this.context, {
    this.isObserveWidgetsBinding = true,
    this.isObserveConnectivity = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) initialize(context);
    });
  }

  final BuildContext context;

  /// Returns the available context that is not disposed.
  ///
  /// Returns null if the context is disposed, otherwise returns [context].
  BuildContext? get safeContext => isDisposed ? null : context;

  final bool isObserveWidgetsBinding;
  final bool isObserveConnectivity;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  bool _isNetworkAvailable = false;

  bool get isNetworkAvailable => _isNetworkAvailable;

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  final StreamSubscriptionRegistry _streamSubscriptionRegistry =
      StreamSubscriptionRegistry();

  void cancelWhenDisposed(StreamSubscription subscription) {
    _streamSubscriptionRegistry.register(subscription);
  }

  @mustCallSuper
  @protected
  void initialize(BuildContext context) {
    if (isObserveWidgetsBinding) WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid || Platform.isIOS) {
      final connectivity = Connectivity();
      connectivity.checkConnectivity().then((value) {
        _connectivityResult = value;
        _isNetworkAvailable = value != ConnectivityResult.none;
      });

      final subscription =
          connectivity.onConnectivityChanged.listen(onConnectivityChanged);
      cancelWhenDisposed(subscription);
    }
  }

  @mustCallSuper
  @protected
  void onConnectivityChanged(ConnectivityResult result) {
    if (Platform.isAndroid || Platform.isIOS) {
      _connectivityResult = result;
      final oldIsNetworkAvailable = _isNetworkAvailable;
      _isNetworkAvailable = result != ConnectivityResult.none;

      if (oldIsNetworkAvailable != _isNetworkAvailable) {
        onNetworkAvailableChanged(_isNetworkAvailable);
      }
    }
  }

  @mustCallSuper
  @protected
  void onNetworkAvailableChanged(bool isNetworkAvailable) {}

  @mustCallSuper
  void onVisibilityChanged(VisibilityInfo info) {}

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
      SnackBar snackBar) {
    if (isDisposed || !context.mounted) {
      return null;
    }
    final state = ScaffoldMessenger.maybeOf(context);
    state?.removeCurrentSnackBar();
    return state?.showSnackBar(snackBar);
  }

  @mustCallSuper
  @protected
  void dispose() {
    _disposeInternal();
  }

  void _disposeInternal() {
    _streamSubscriptionRegistry.cancelAll();
    if (isObserveWidgetsBinding) WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true;
  }
}

abstract base class ChangeNotifierViewModel extends ViewModel
    with ChangeNotifier {
  ChangeNotifierViewModel(
    super.context, {
    super.isObserveWidgetsBinding,
    super.isObserveConnectivity,
  });

  @override
  void dispose() {
    super._disposeInternal();
    super.dispose();
  }
}

abstract base class StateViewModel<State extends UiState>
    extends ChangeNotifierViewModel {
  StateViewModel(
    super.context, {
    super.isObserveWidgetsBinding,
    super.isObserveConnectivity,
  });

  late State _state = getInitialState();

  State get state => _state;

  @protected
  State getInitialState();

  @protected
  void setState(State state) {
    if (isDisposed || state == _state) {
      return;
    }
    _state = state;
    notifyListeners();
  }
}
