import 'package:flutter_test/flutter_test.dart';

import 'package:class_two_qk_quiz/data/sections_data.dart';
import 'package:class_two_qk_quiz/repositories/question_repository.dart';

void main() {
  late QuestionRepository questions;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    questions = await QuestionRepository.load();
  });

  test('every section has its own JSON file with at least 20 questions', () {
    for (final section in kSections) {
      expect(questions.countForSection(section.id), greaterThanOrEqualTo(20), reason: section.id);
    }
  });

  test('every question is well-formed and has a unique id', () {
    final all = questions.getForSections(const []);
    final ids = <String>{};
    for (final q in all) {
      expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
      expect(q.options, hasLength(4), reason: q.id);
      expect(q.options.toSet(), hasLength(4), reason: '${q.id} has duplicate options');
      expect(q.correctAnswerIndex, inInclusiveRange(0, 3), reason: q.id);
      expect(q.questionText.trim(), isNotEmpty, reason: q.id);
      expect(q.explanation.trim(), isNotEmpty, reason: q.id);
    }
  });
}
