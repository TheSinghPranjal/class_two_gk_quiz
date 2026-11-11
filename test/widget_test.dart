import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:class_two_qk_quiz/core/providers/shared_preferences_provider.dart';
import 'package:class_two_qk_quiz/features/home/presentation/home_screen.dart';
import 'package:class_two_qk_quiz/features/splash/presentation/splash_screen.dart';
import 'package:class_two_qk_quiz/main.dart';
import 'package:class_two_qk_quiz/repositories/question_repository.dart';

void main() {
  late QuestionRepository questions;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    questions = await QuestionRepository.load();
  });

  testWidgets('Home screen renders the Rapid Fire banner and sections', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          questionBankProvider.overrideWith((ref) => questions),
        ],
        child: const QuickQuizApp(),
      ),
    );
    // The splash holds, then fades to home. The home background animates
    // forever, so pump a fixed time instead of waiting for it to settle.
    await tester.pump(SplashScreen.displayDuration);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Rapid Fire'), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Choose Your Adventure'), findsOneWidget);
  });
}
