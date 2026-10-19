import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_result.dart';

/// Persists completed quiz attempts locally so the History screen can list
/// them across app launches.
class HistoryRepository {
  static const _key = 'quiz_history_v1';

  final SharedPreferences _prefs;

  HistoryRepository(this._prefs);

  List<QuizResult> loadAll() {
    final raw = _prefs.getStringList(_key) ?? const [];
    return raw
        .map((s) => QuizResult.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> save(List<QuizResult> results) async {
    await _prefs.setStringList(_key, results.map((r) => jsonEncode(r.toJson())).toList());
  }
}
