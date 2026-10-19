import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/quiz_config.dart';
import '../../../models/quiz_enums.dart';
import '../../../models/quiz_result.dart';
import '../../../models/quiz_state.dart';
import '../../../repositories/question_repository.dart';
import '../../history/providers/history_provider.dart';

/// Drives a single quiz session (Rapid Fire or Normal — the mode only
/// changes the [QuizConfig] passed to [start]). All scoring, randomisation,
/// and timer logic lives here; the UI only watches [QuizState] and calls
/// these methods.
class QuizController extends AutoDisposeNotifier<QuizState> {
  Timer? _timer;
  final Random _random = Random();
  bool _disposed = false;

  /// Bumped on every [start] so a delayed auto-advance from a previous
  /// session (e.g. before a restart) can tell it is stale.
  int _session = 0;

  @override
  QuizState build() {
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    return const QuizState();
  }

  void start(QuizConfig config) {
    _timer?.cancel();
    _session++;
    final repo = ref.read(questionRepositoryProvider);
    final pool = repo.getForSections(config.sectionIds).toList()..shuffle(_random);
    final questions = pool.map((q) => q.shuffledOptions(_random)).toList();

    state = QuizState(
      status: QuizStatus.playing,
      config: config,
      questions: questions,
      currentIndex: 0,
      remainingSeconds: config.durationSeconds,
    );

    if (questions.isEmpty) {
      _complete();
      return;
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_disposed) return;
    if (state.status != QuizStatus.playing && state.status != QuizStatus.showingAnswer) return;
    final next = state.remainingSeconds - 1;
    if (next <= 0) {
      state = state.copyWith(remainingSeconds: 0);
      _complete();
    } else {
      state = state.copyWith(remainingSeconds: next);
    }
  }

  void selectOption(int index) {
    // selectedIndex is set during the brief success flash after a correct
    // answer; ignore further taps until the next question appears.
    if (state.status != QuizStatus.playing || state.selectedIndex != null) return;
    final question = state.currentQuestion;
    final config = state.config;
    if (question == null || config == null) return;

    final isCorrect = index == question.correctAnswerIndex;
    if (isCorrect) {
      state = state.copyWith(
        score: state.score + 1,
        correctCount: state.correctCount + 1,
        selectedIndex: index,
      );
      _autoAdvanceAfterCorrect();
    } else {
      final penalty = config.negativeMarking ? 1 : 0;
      state = state.copyWith(
        score: state.score - penalty,
        wrongCount: state.wrongCount + 1,
        selectedIndex: index,
        status: QuizStatus.showingAnswer,
      );
    }
  }

  Future<void> _autoAdvanceAfterCorrect() async {
    final session = _session;
    final index = state.currentIndex;
    await Future.delayed(const Duration(milliseconds: 380));
    if (_disposed || session != _session || index != state.currentIndex) return;
    // If the user paused/exited during the brief success flash, don't fight
    // that transition — just leave the state as-is.
    if (state.status != QuizStatus.playing) return;
    _goToNext();
  }

  void next() {
    if (state.status != QuizStatus.showingAnswer) return;
    _goToNext();
  }

  void skip() {
    if (state.status != QuizStatus.playing || state.selectedIndex != null) return;
    state = state.copyWith(skippedCount: state.skippedCount + 1);
    _goToNext();
  }

  void _goToNext() {
    if (state.remainingSeconds <= 0) {
      _complete();
      return;
    }
    if (!state.hasNextQuestion) {
      _complete();
      return;
    }
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      selectedIndex: null,
      status: QuizStatus.playing,
    );
  }

  void pause() {
    if (state.status != QuizStatus.playing && state.status != QuizStatus.showingAnswer) return;
    _timer?.cancel();
    state = state.copyWith(status: QuizStatus.paused, statusBeforePause: state.status);
  }

  void resume() {
    if (state.status != QuizStatus.paused) return;
    state = state.copyWith(status: state.statusBeforePause ?? QuizStatus.playing);
    _startTimer();
  }

  void restart() {
    final config = state.config;
    if (config != null) start(config);
  }

  void exit() {
    _timer?.cancel();
    state = state.copyWith(status: QuizStatus.exited);
  }

  void _complete() {
    _timer?.cancel();
    state = state.copyWith(status: QuizStatus.completed);

    final config = state.config;
    if (config == null) return;
    final elapsed = config.durationSeconds - state.remainingSeconds;
    final result = QuizResult(
      id: '${DateTime.now().microsecondsSinceEpoch}',
      mode: config.mode,
      sectionIds: config.sectionIds,
      score: state.score,
      correct: state.correctCount,
      wrong: state.wrongCount,
      skipped: state.skippedCount,
      totalAnswered: state.totalAnswered,
      durationSeconds: elapsed.clamp(0, config.durationSeconds),
      timestamp: DateTime.now(),
    );
    ref.read(historyControllerProvider.notifier).add(result);
  }
}

final quizControllerProvider = NotifierProvider.autoDispose<QuizController, QuizState>(
  QuizController.new,
);
