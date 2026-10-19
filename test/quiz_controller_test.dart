import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:class_two_qk_quiz/core/providers/shared_preferences_provider.dart';
import 'package:class_two_qk_quiz/features/quiz/providers/quiz_controller.dart';
import 'package:class_two_qk_quiz/models/quiz_config.dart';
import 'package:class_two_qk_quiz/models/quiz_enums.dart';
import 'package:class_two_qk_quiz/repositories/question_repository.dart';

void main() {
  late ProviderContainer container;
  late QuestionRepository questions;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    questions = await QuestionRepository.load();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        questionRepositoryProvider.overrideWithValue(questions),
      ],
    );
    // quizControllerProvider is autoDispose; without an active listener the
    // container would tear it down between calls in these tests.
    container.listen(quizControllerProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('correct answer adds a point and advances after a short delay', () async {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.normal(sectionId: 'mathematics', sectionTitle: 'Mathematics'));

    final question = container.read(quizControllerProvider).currentQuestion!;
    controller.selectOption(question.correctAnswerIndex);

    expect(container.read(quizControllerProvider).score, 1);
    expect(container.read(quizControllerProvider).correctCount, 1);

    await Future.delayed(const Duration(milliseconds: 450));
    expect(container.read(quizControllerProvider).currentIndex, 1);
    expect(container.read(quizControllerProvider).status, QuizStatus.playing);
  });

  test('wrong answer in rapid fire subtracts a point and requires NEXT to advance', () {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.rapidFire(sectionIds: ['mathematics']));

    final question = container.read(quizControllerProvider).currentQuestion!;
    final wrongIndex = (question.correctAnswerIndex + 1) % question.options.length;
    controller.selectOption(wrongIndex);

    final afterWrong = container.read(quizControllerProvider);
    expect(afterWrong.score, -1);
    expect(afterWrong.wrongCount, 1);
    expect(afterWrong.status, QuizStatus.showingAnswer);
    expect(afterWrong.currentIndex, 0, reason: 'should not advance until NEXT is tapped');

    controller.next();
    expect(container.read(quizControllerProvider).currentIndex, 1);
    expect(container.read(quizControllerProvider).status, QuizStatus.playing);
  });

  test('wrong answer in a normal quiz does not subtract points', () {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.normal(sectionId: 'science', sectionTitle: 'Science'));

    final question = container.read(quizControllerProvider).currentQuestion!;
    final wrongIndex = (question.correctAnswerIndex + 1) % question.options.length;
    controller.selectOption(wrongIndex);

    expect(container.read(quizControllerProvider).score, 0);
    expect(container.read(quizControllerProvider).wrongCount, 1);
  });

  test('skip does not change the score and moves to the next question', () {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.rapidFire(sectionIds: ['animals']));

    controller.skip();
    final state = container.read(quizControllerProvider);
    expect(state.score, 0);
    expect(state.skippedCount, 1);
    expect(state.currentIndex, 1);
  });

  test('double-tapping an option only scores once', () {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.normal(sectionId: 'english', sectionTitle: 'English'));

    final question = container.read(quizControllerProvider).currentQuestion!;
    final wrongIndex = (question.correctAnswerIndex + 1) % question.options.length;
    controller.selectOption(wrongIndex);
    controller.selectOption(wrongIndex);
    controller.selectOption(question.correctAnswerIndex);

    expect(container.read(quizControllerProvider).wrongCount, 1);
    expect(container.read(quizControllerProvider).correctCount, 0);
  });

  test('double-tapping the correct answer scores once and advances one question', () async {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.normal(sectionId: 'mathematics', sectionTitle: 'Mathematics'));

    final question = container.read(quizControllerProvider).currentQuestion!;
    controller.selectOption(question.correctAnswerIndex);
    controller.selectOption(question.correctAnswerIndex);
    controller.skip();

    expect(container.read(quizControllerProvider).score, 1);
    expect(container.read(quizControllerProvider).skippedCount, 0);

    await Future.delayed(const Duration(milliseconds: 450));
    expect(container.read(quizControllerProvider).currentIndex, 1);
  });

  test('restart during the success flash does not skip the first new question', () async {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.normal(sectionId: 'mathematics', sectionTitle: 'Mathematics'));

    final question = container.read(quizControllerProvider).currentQuestion!;
    controller.selectOption(question.correctAnswerIndex);
    controller.restart();

    await Future.delayed(const Duration(milliseconds: 450));
    expect(container.read(quizControllerProvider).currentIndex, 0);
    expect(container.read(quizControllerProvider).score, 0);
  });

  test('pause stops the timer and resume continues from the same time', () async {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.rapidFire(sectionIds: ['mathematics']));

    await Future.delayed(const Duration(milliseconds: 1100));
    controller.pause();
    final pausedRemaining = container.read(quizControllerProvider).remainingSeconds;
    expect(container.read(quizControllerProvider).status, QuizStatus.paused);

    await Future.delayed(const Duration(milliseconds: 1100));
    expect(container.read(quizControllerProvider).remainingSeconds, pausedRemaining,
        reason: 'timer must not tick while paused');

    controller.resume();
    expect(container.read(quizControllerProvider).status, QuizStatus.playing);
  });

  test('no questions available for the selected sections completes immediately', () {
    final controller = container.read(quizControllerProvider.notifier);
    controller.start(QuizConfig.rapidFire(sectionIds: ['not_a_real_section']));

    final state = container.read(quizControllerProvider);
    expect(state.status, QuizStatus.completed);
    expect(state.questions, isEmpty);
  });
}
