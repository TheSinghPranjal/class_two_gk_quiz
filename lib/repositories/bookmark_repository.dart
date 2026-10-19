import 'package:shared_preferences/shared_preferences.dart';

/// Persists bookmarked question ids locally.
class BookmarkRepository {
  static const _key = 'bookmarked_question_ids_v1';

  final SharedPreferences _prefs;

  BookmarkRepository(this._prefs);

  Set<String> loadAll() => (_prefs.getStringList(_key) ?? const []).toSet();

  Future<void> save(Set<String> ids) async {
    await _prefs.setStringList(_key, ids.toList());
  }
}
