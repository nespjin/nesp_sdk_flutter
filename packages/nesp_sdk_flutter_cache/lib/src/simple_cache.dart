// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:nesp_sdk_flutter_cache/src/cache.dart';

class SimpleCache<K, V> {
  SimpleCache(int maxSize, Duration liveTime) {
    if (maxSize <= 0) {
      throw ArgumentError('maxSize must be greater than 0');
    }
    _maxSize = maxSize;
    _liveTime = liveTime;
    _map = LinkedHashMap();
  }

  factory SimpleCache.fromLiveTime(Duration liveTime) =>
      SimpleCache(1 << 32, liveTime);

  late LinkedHashMap<K, CacheEntry<K, V>> _map;

  Duration _liveTime = Duration.zero;
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
    CacheEntry<K, V>? entry = _map[key];
    var expired = false;
    if (entry != null && !(expired = isExpired(entry))) {
      _hitCount++;
      entry.accessTime = DateTime.now();
      _afterNodeAccessForKey(key);
      return entry.value;
    }

    if (entry != null) {
      _afterNodeAccessForKey(key);
    }

    _missCount++;

    V? createValue = create(key);
    if (createValue == null) {
      if (expired) {
        trimToSize(maxSize);
      }
      return null;
    }
    _createCount++;
    CacheEntry<K, V> createValueEntry =
        CacheEntry(key, createValue, DateTime.now());
    _map.update(
      key,
      (value) => createValueEntry,
      ifAbsent: () => createValueEntry,
    );
    _size += _safeSizeOf(key, createValue);

    trimToSize(_maxSize);
    return createValue;
  }

  bool isExpired(CacheEntry<dynamic, dynamic> entry) =>
      DateTime.now().difference(entry.insertTime) > _liveTime;

  void operator []=(K key, V value) {
    put(key, value);
  }

  V? put(K key, V value) {
    V? previous;
    _putCount++;
    CacheEntry<K, V> valueEntry = CacheEntry(key, value, DateTime.now());
    _map.update(
      key,
      (previousValue) {
        previous = previousValue.value;
        return valueEntry;
      },
      ifAbsent: () => valueEntry,
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
  void _afterNodeAccess(MapEntry<K, CacheEntry<K, V>> entry) {
    _map.remove(entry.key);
    _map.update(
      entry.key,
      (value) => entry.value,
      ifAbsent: () => entry.value,
    );
  }

  void trimToSize(int maxSize) {
    // remove all expired entries at first.
    _map.removeWhere((key, value) {
      final expired = isExpired(value);
      if (expired) {
        _size -= _safeSizeOf(key, value.value);
        _evictionCount++;

        entryRemoved(true, key, value.value, null);
      }
      return expired;
    });

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
      MapEntry<K, CacheEntry<K, V>> toEvict = _map.entries.first;
      key = toEvict.key;
      value = toEvict.value.value;
      _map.remove(key);
      _size -= _safeSizeOf(key, value);
      _evictionCount++;

      entryRemoved(true, key, value, null);
    }
  }

  V? remove(K key) {
    CacheEntry<K, V>? previous = _map.remove(key);
    if (previous != null) {
      _size -= _safeSizeOf(key, previous.value);
      entryRemoved(false, key, previous.value, null);
    }
    return previous?.value;
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

  Duration get liveTime => _liveTime;

  Map<K, V> get snapshot => LinkedHashMap.from(_map);

  bool containsKey(K key) => _map.containsKey(key);

  bool containsValue(V value) => _map.containsValue(value);

  @override
  String toString() {
    int accesses = hitCount + missCount;
    int hitPercent = accesses != 0 ? 100 * hitCount ~/ accesses : 0;
    return 'SimpleCache[maxSize=$maxSize,hits=$hitCount,misses=$missCount,hitRate=$hitPercent%]';
  }
}
