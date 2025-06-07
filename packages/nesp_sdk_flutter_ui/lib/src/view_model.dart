import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nesp_sdk_dart_core/nesp_sdk_dart_core.dart';
import 'package:nesp_sdk_flutter_ui/src/ui_state_store.dart';
import 'package:nesp_sdk_flutter_ui/src/ui_state.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class ViewModel with WidgetsBindingObserver {
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

abstract class ChangeNotifierViewModel extends ViewModel with ChangeNotifier {
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

abstract class StateViewModel<S extends UiState>
    extends ChangeNotifierViewModel {
  StateViewModel(
    super.context, {
    super.isObserveWidgetsBinding,
    super.isObserveConnectivity,
    S? initialState,
    S? emptyState,
    this.keepState = false,
    this.isUserScope = false,
    String? stateKey,
  }) {
    this.initialState = initialState ?? createInitialState();
    this.emptyState = emptyState ?? createEmptyState() ?? this.initialState;
    this.stateKey = stateKey ?? runtimeType.toString();
    onRestoreState();
  }

  /// 是否为用户作用域
  ///
  /// 默认为false, 若为true, 则状态将保存在用户作用域中, 当用户退出时, 状态将被清除
  final bool isUserScope;

  /// 是否保存状态
  ///
  /// 默认为 false, 当设置为保存状态时, 状态将保存在 [UiStateStore] 中,
  /// 每次重新创建 ViewModel 时, 会从 [UiStateStore] 中恢复状态
  final bool keepState;

  /// UI 状态的 key
  ///
  /// 默认为当前 ViewModel 的类型名, 用于存储和恢复 UI 状态
  late final String stateKey;

  /// UI 状态存储器
  UiStateStore? stateStore;

  late S _state = initialState;

  /// UI 状态，初始值为 [initialState]
  S get state => _state;

  /// 初始状态，若通过构造参数传入的值为 null，则默认为 [createInitialState] 方法返回值
  late final S initialState;

  /// 空状态
  ///
  /// 当构造参数传入 [emptyState] 值为 null 时，默认为 [createEmptyState] 方法返回值，
  /// 若 [createEmptyState] 方法返回值为 null 时，默认为 [initialState]
  ///
  /// 当 [clearState] 被调用时，将重置为 [emptyState]
  late final S emptyState;

  /// 创建初始状态，默认抛出 [UnimplementedError]，当通过构造参数传入 [initialState] 值为 null 时调用
  S createInitialState() => throw UnimplementedError();

  /// 创建空状态
  S? createEmptyState() => null;

  /// 设置状态
  void setState(S state, {bool notify = true}) {
    if (isDisposed) return;

    try {
      if (state == _state) return;
    } on Error catch (_) {
      // The _state not initialized
    }

    _state = state;
    if (notify) notifyListeners();
  }

  @protected
  void onSaveState() {
    if (!keepState) return;

    if (stateStore == null) {
      throw Exception('The stateStore is null, please set it first.');
    }
    stateStore!.setState(stateKey, _state);
  }

  @protected
  void onRestoreState() {
    if (!keepState) return;
    stateStore ??= UiStateStoreProvider.of(context).store;
    final state = stateStore!.getState<S>(stateKey);
    if (state != null) setState(state);
  }

  @override
  void dispose() {
    onSaveState();
    super.dispose();
  }
}
