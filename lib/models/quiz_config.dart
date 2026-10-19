import 'package:flutter/foundation.dart';

import 'quiz_enums.dart';

/// Configuration for a single quiz session, built by the setup/section
/// screens and consumed by the quiz controller.
@immutable
class QuizConfig {
  final QuizMode mode;

  /// Empty list means "random / all enabled sections".
  final List<String> sectionIds;
  final int durationSeconds;
  final bool negativeMarking;

  /// Friendly label shown in the app bar, e.g. "Mathematics" or "Rapid Fire".
  final String title;

  const QuizConfig({
    required this.mode,
    required this.sectionIds,
    required this.durationSeconds,
    required this.negativeMarking,
    required this.title,
  });

  bool get isRandom => sectionIds.isEmpty;

  factory QuizConfig.rapidFire({required List<String> sectionIds}) {
    return QuizConfig(
      mode: QuizMode.rapidFire,
      sectionIds: sectionIds,
      durationSeconds: 30,
      negativeMarking: true,
      title: 'Rapid Fire',
    );
  }

  factory QuizConfig.normal({required String sectionId, required String sectionTitle}) {
    return QuizConfig(
      mode: QuizMode.normal,
      sectionIds: [sectionId],
      durationSeconds: 300,
      negativeMarking: false,
      title: sectionTitle,
    );
  }
}
