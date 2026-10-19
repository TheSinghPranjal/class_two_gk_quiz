import 'package:flutter/foundation.dart';

import 'question.dart';
import 'quiz_config.dart';
import 'quiz_enums.dart';

/// Sentinel used so [QuizState.copyWith] can tell "leave unchanged" apart
/// from "set explicitly to null" for nullable fields.
class _Unset {
  const _Unset();
}

const _unset = _Unset();

@immutable
class QuizState {
  final QuizStatus status;
  final QuizConfig? config;
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int remainingSeconds;
  final int? selectedIndex;

  /// Status to restore to on resume (playing or showingAnswer).
  final QuizStatus? statusBeforePause;

  const QuizState({
    this.status = QuizStatus.initial,
    this.config,
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.skippedCount = 0,
    this.remainingSeconds = 0,
    this.selectedIndex,
    this.statusBeforePause,
  });

  Question? get currentQuestion =>
      currentIndex >= 0 && currentIndex < questions.length ? questions[currentIndex] : null;

  int get totalAnswered => correctCount + wrongCount;

  int get questionsSeen => correctCount + wrongCount + skippedCount;

  bool get hasNextQuestion => currentIndex + 1 < questions.length;

  QuizState copyWith({
    QuizStatus? status,
    QuizConfig? config,
    List<Question>? questions,
    int? currentIndex,
    int? score,
    int? correctCount,
    int? wrongCount,
    int? skippedCount,
    int? remainingSeconds,
    Object? selectedIndex = _unset,
    Object? statusBeforePause = _unset,
  }) {
    return QuizState(
      status: status ?? this.status,
      config: config ?? this.config,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      skippedCount: skippedCount ?? this.skippedCount,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      selectedIndex: identical(selectedIndex, _unset) ? this.selectedIndex : selectedIndex as int?,
      statusBeforePause:
          identical(statusBeforePause, _unset) ? this.statusBeforePause : statusBeforePause as QuizStatus?,
    );
  }
}
