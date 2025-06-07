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
