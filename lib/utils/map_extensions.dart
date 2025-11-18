extension MapExtensions<K, V> on Map<K, V> {
  Iterable<(K, V)> get records sync* {
    for (var key in keys) {
      yield (key, this[key]!);
    }
  }
}
