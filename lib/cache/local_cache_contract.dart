abstract class ILocalCache {
  Future<void> save(String key, Map<String, dynamic> json);
  Map<String, dynamic> fetch(String key);
}
