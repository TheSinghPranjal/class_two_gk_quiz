import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:class_two_qk_quiz/core/providers/shared_preferences_provider.dart';
import 'package:class_two_qk_quiz/features/quiz/presentation/quiz_screen.dart';
import 'package:class_two_qk_quiz/features/quiz/presentation/widgets/option_button.dart';
import 'package:class_two_qk_quiz/features/quiz/providers/quiz_controller.dart';
import 'package:class_two_qk_quiz/models/quiz_config.dart';
import 'package:class_two_qk_quiz/repositories/question_repository.dart';

void main() {
  late QuestionRepository questions;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    questions = await QuestionRepository.load();
  });

  testWidgets('rapid fire gameplay: wrong-answer correction, correct-answer auto-advance, pause/resume', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        questionRepositoryProvider.overrideWithValue(questions),
      ],
    );
    addTearDown(container.dispose);
    // Phone-sized viewport so the quiz scene + options lay out as on device.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: QuizScreen(config: QuizConfig.rapidFire(sectionIds: const ['mathematics'])),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(OptionButton), findsNWidgets(4));

    final firstQuestion = container.read(quizControllerProvider).currentQuestion!;
    final wrongIndex = (firstQuestion.correctAnswerIndex + 1) % 4;

    await tester.ensureVisible(find.byType(OptionButton).at(wrongIndex));
    await tester.tap(find.byType(OptionButton).at(wrongIndex));
    await tester.pump();

    expect(find.text('Not quite!'), findsOneWidget);
    expect(find.text('NEXT'), findsOneWidget);
    expect(container.read(quizControllerProvider).score, -1);

    await tester.tap(find.text('NEXT'));
    await tester.pump();

    final secondState = container.read(quizControllerProvider);
    expect(secondState.currentIndex, 1);
    final correctIndex = secondState.currentQuestion!.correctAnswerIndex;

    await tester.ensureVisible(find.byType(OptionButton).at(correctIndex));
    await tester.tap(find.byType(OptionButton).at(correctIndex));
    await tester.pump(const Duration(milliseconds: 500));

    final thirdState = container.read(quizControllerProvider);
    expect(thirdState.currentIndex, 2, reason: 'correct answer should auto-advance without a NEXT tap');
    expect(thirdState.score, 0, reason: '-1 for the wrong answer, +1 for the correct one');

    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();
    expect(find.text('PAUSED'), findsOneWidget);
    expect(find.text('RESUME'), findsOneWidget);
    expect(find.text('RESTART'), findsOneWidget);

    await tester.tap(find.text('RESUME'));
    await tester.pump();
    expect(find.text('PAUSED'), findsNothing);

    // Stop the ticking timer before the test binding tears down the tree.
    container.read(quizControllerProvider.notifier).pause();
    // The quiz scene has looping idle animations; unmount so they stop.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
