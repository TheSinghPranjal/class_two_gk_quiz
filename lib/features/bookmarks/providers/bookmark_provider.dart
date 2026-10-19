import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../repositories/bookmark_repository.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(ref.watch(sharedPreferencesProvider));
});

final bookmarkControllerProvider = NotifierProvider<BookmarkController, Set<String>>(
  BookmarkController.new,
);

class BookmarkController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    return ref.watch(bookmarkRepositoryProvider).loadAll();
  }

  bool isBookmarked(String questionId) => state.contains(questionId);

  void toggle(String questionId) {
    final updated = Set<String>.from(state);
    if (!updated.remove(questionId)) {
      updated.add(questionId);
    }
    state = updated;
    ref.read(bookmarkRepositoryProvider).save(updated);
  }
}
