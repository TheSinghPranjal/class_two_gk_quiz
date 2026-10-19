import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks which sections are selected on the Rapid Fire setup screen.
/// An empty set means "Random / All Sections".
class RapidFireSetupController extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String sectionId) {
    final updated = Set<String>.from(state);
    if (!updated.remove(sectionId)) {
      updated.add(sectionId);
    }
    state = updated;
  }

  void selectRandom() => state = <String>{};

  bool get isRandom => state.isEmpty;
}

final rapidFireSetupProvider = NotifierProvider<RapidFireSetupController, Set<String>>(
  RapidFireSetupController.new,
);
