// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/foundation.dart';

class LruCache<K, V> {
  LruCache(int maxSize) {
    if (maxSize <= 0) {
      throw ArgumentError('maxSize must be greater than 0');
    }
    _maxSize = maxSize;
    _map = LinkedHashMap();
  }

  late LinkedHashMap<K, V> _map;

  int _size = 0;
  late int _maxSize;

  int _putCount = 0;
  int _createCount = 0;
  int _evictionCount = 0;
  int _hitCount = 0;
  int _missCount = 0;

  void resize(int maxSize) {
    if (maxSize <= 0) {
      throw ArgumentError('maxSize must be greater than 0');
    }
    _maxSize = maxSize;
    trimToSize(maxSize);
  }

  V? operator [](K key) {
    return get(key);
  }

  V? get(K key) {
    V? mapValue = _map[key];
    if (mapValue != null) {
      _afterNodeAccessForKey(key);
      _hitCount++;
      return mapValue;
    }
    _missCount++;

    V? createValue = create(key);
    if (createValue == null) {
      return null;
    }
    _createCount++;
    _map.update(
      key,
      (value) => createValue,
      ifAbsent: () => createValue,
    );
    _size += _safeSizeOf(key, createValue);

    trimToSize(_maxSize);
    return createValue;
  }

  void operator []=(K key, V value) {
    put(key, value);
  }

  V? put(K key, V value) {
    V? previous;
    _putCount++;
    _map.update(
      key,
      (previousValue) {
        previous = previousValue;
        return value;
      },
      ifAbsent: () => value,
    );
    _size += _safeSizeOf(key, value);
    if (previous != null) {
      _size -= _safeSizeOf(key, previous as V);
      entryRemoved(false, key, previous, value);

      _afterNodeAccessForKey(key);
    }

    trimToSize(_maxSize);
    return previous;
  }

  void _afterNodeAccessForKey(K key) {
    final entry = _map.entries.firstWhere((element) => element.key == key);
    _afterNodeAccess(entry);
  }

  /// Move the node to last.
  void _afterNodeAccess(MapEntry<K, V> entry) {
    _map.remove(entry.key);
    _map.update(
      entry.key,
      (value) => entry.value,
      ifAbsent: () => entry.value,
    );
  }

  void trimToSize(int maxSize) {
    while (true) {
      K key;
      V value;
      if (_size < 0 || (_map.isEmpty && _size != 0)) {
        throw StateError('sizeOf is reporting inconsistent results!');
      }

      if (_size <= maxSize || _map.isEmpty) {
        break;
      }

      // The eldest is at header.
      MapEntry<K, V> toEvict = _map.entries.first;
      key = toEvict.key;
      value = toEvict.value;
      _map.remove(key);
      _size -= _safeSizeOf(key, value);
      _evictionCount++;

      entryRemoved(true, key, value, null);
    }
  }

  V? remove(K key) {
    V? previous = _map.remove(key);
    if (previous != null) {
      _size -= _safeSizeOf(key, previous);
      entryRemoved(false, key, previous, null);
    }
    return previous;
  }

  @protected
  void entryRemoved(bool evicted, K key, V? oldValue, V? newValue) {}

  @protected
  V? create(K key) {
    return null;
  }

  int _safeSizeOf(K key, V value) {
    int result = sizeOf(key, value);
    if (result < 0) {
      throw StateError('Negative size: $key=$value');
    }
    return result;
  }

  @protected
  int sizeOf(K key, V value) {
    return 1;
  }

  void evictAll() {
    trimToSize(-1);
  }

  int get size => _size;

  int get maxSize => _maxSize;

  int get hitCount => _hitCount;

  int get missCount => _missCount;

  int get createCount => _createCount;

  int get putCount => _putCount;

  int get evictionCount => _evictionCount;

  Map<K, V> get snapshot => LinkedHashMap.from(_map);

  bool containsKey(K key) => _map.containsKey(key);

  bool containsValue(V value) => _map.containsValue(value);

  @override
  String toString() {
    int accesses = hitCount + missCount;
    int hitPercent = accesses != 0 ? 100 * hitCount ~/ accesses : 0;
    return 'LruCache[maxSize=$maxSize,hits=$hitCount,misses=$missCount,hitRate=$hitPercent%]';
  }
}
