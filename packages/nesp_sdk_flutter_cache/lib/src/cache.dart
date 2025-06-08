// Copyright 2025, the nesp_sdk_flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class CacheEntry<K, V> {
  CacheEntry(this.key, this.value, this.insertTime) {
    accessTime = insertTime;
  }

  K key;
  V value;
  DateTime insertTime = DateTime.now();
  DateTime accessTime = DateTime.now();
}

abstract class Cache {}
