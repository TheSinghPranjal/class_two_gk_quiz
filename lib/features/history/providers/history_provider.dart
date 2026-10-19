import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../models/quiz_result.dart';
import '../../../repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(sharedPreferencesProvider));
});

final historyControllerProvider = NotifierProvider<HistoryController, List<QuizResult>>(
  HistoryController.new,
);

class HistoryController extends Notifier<List<QuizResult>> {
  @override
  List<QuizResult> build() {
    return ref.watch(historyRepositoryProvider).loadAll();
  }

  void add(QuizResult result) {
    final updated = [result, ...state];
    state = updated;
    ref.read(historyRepositoryProvider).save(updated);
  }

  /// Best score achieved for a single-section normal quiz.
  int? bestScoreForSection(String sectionId) {
    final matches = state.where(
      (r) => r.mode.name == 'normal' && r.sectionIds.length == 1 && r.sectionIds.first == sectionId,
    );
    if (matches.isEmpty) return null;
    return matches.map((r) => r.score).reduce((a, b) => a > b ? a : b);
  }

  int attemptsForSection(String sectionId) {
    return state
        .where((r) => r.mode.name == 'normal' && r.sectionIds.length == 1 && r.sectionIds.first == sectionId)
        .length;
  }
}
