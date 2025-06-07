import 'package:flutter/material.dart';
import 'package:nesp_sdk_flutter_ui/nesp_sdk_flutter_ui.dart';

// class UiStateNode<K> {
//   const UiStateNode({
//     required this.key,
//     required this.state,
//   });

//   final K key;
//   final UiState state;
// }

/// A set of ui States with the same id
///
/// It's used to manage a set of ui states
class UiStateGroup {
  const UiStateGroup({
    required this.id,
    required this.children,
  });

  final String id;
  final Map<String, UiState> children;
}

/// Holding a set of ui state groups
///
/// The default group is used to store ui state
/// Use the user group to store the ui state in the user scope
class UiStateStore {
  final Map<String /** group id */, UiStateGroup> _store = {};
  static const String _keyGroupDefault =
      'flutter_sdk_package/ui_state_store/group/default';
  static const String _keyGroupUser =
      'flutter_sdk_package/ui_state_store/group/user';

  void setState(String key, UiState state) {
    setStateOfGroup(_keyGroupDefault, key, state);
  }

  S? getState<S extends UiState>(String key) {
    return getStateOfGroup(_keyGroupDefault, key);
  }

  void removeState(String key) {
    removeStateOfGroup(_keyGroupDefault, key);
  }

  void setUserState(String key, UiState state) {
    setStateOfGroup(_keyGroupUser, key, state);
  }

  S? getUserState<S extends UiState>(String key) {
    return getStateOfGroup(_keyGroupUser, key);
  }

  void removeUserState(String key) {
    removeStateOfGroup(_keyGroupUser, key);
  }

  UiStateGroup getOrCreateUserGroup() {
    return getOrCreateGroup(_keyGroupUser);
  }

  void removeUserGroup() {
    removeGroup(_keyGroupUser);
  }

  void setStateOfGroup(String groupId, String key, UiState state) {
    var group = getOrCreateGroup(groupId);
    group.children[key] = state;
  }

  S? getStateOfGroup<S extends UiState>(String groupId, String key) {
    var group = getOrCreateGroup(groupId);
    var val = group.children[key];
    if (val == null) {
      return null;
    }
    return val as S?;
  }

  void removeStateOfGroup(String groupId, String key) {
    var group = getOrCreateGroup(groupId);
    group.children.remove(key);
  }

  UiStateGroup getOrCreateGroup(String id) {
    var group = getGroup(id);
    group ??= UiStateGroup(id: id, children: {});
    setGroup(group);
    return group;
  }

  UiStateGroup? getGroup(String id) {
    return _store[id];
  }

  void setGroup(UiStateGroup group) {
    _store[group.id] = group;
  }

  void removeGroup(String id) {
    _store.remove(id);
  }

  void clear() {
    _store.clear();
  }
}

class UiStateStoreProvider extends InheritedWidget {
  const UiStateStoreProvider({
    super.key,
    required this.store,
    required super.child,
  });

  final UiStateStore store;

  static UiStateStoreProvider of(BuildContext context, {bool listen = false}) {
    late UiStateStoreProvider? provider;
    if (listen) {
      provider =
          context.dependOnInheritedWidgetOfExactType<UiStateStoreProvider>();
    } else {
      provider = context.findAncestorWidgetOfExactType<UiStateStoreProvider>();
    }

    if (provider == null) {
      throw Exception('UiStateStoreProvider not found');
    }

    return provider;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return this != oldWidget ||
        store != (oldWidget as UiStateStoreProvider).store;
  }
}
