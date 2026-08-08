import 'package:bears_video/src/rust/api/database.dart' as rust_database;

class SearchHistoryRepository {
  Future<List<String>> getRecent({int limit = 20}) {
    return rust_database.searchHistoryGetRecent(limit: limit);
  }

  Future<void> save(String keyword) {
    return rust_database.searchHistorySave(keyword: keyword);
  }

  Future<void> clear() => rust_database.searchHistoryClear();
}
