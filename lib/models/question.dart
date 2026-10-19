import 'dart:math';

import 'package:flutter/foundation.dart';

/// A single quiz question. Immutable — always produce a new instance
/// (e.g. via [shuffledOptions]) rather than mutating one in place.
@immutable
class Question {
  final String id;
  final String sectionId;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String difficulty;
  // Reserved for future image-based questions; unused today.
  final String? imagePath;

  const Question({
    required this.id,
    required this.sectionId,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.difficulty = 'easy',
    this.imagePath,
  });

  /// Parses one entry of an `assets/questions/<sectionId>.json` file. The
  /// JSON schema matches the Class 1 quiz (`question`, `correctIndex`,
  /// `funFact`, numeric `difficulty` 1–3).
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      sectionId: json['sectionId'] as String,
      questionText: json['question'] as String,
      options: List<String>.unmodifiable(json['options'] as List<dynamic>),
      correctAnswerIndex: json['correctIndex'] as int,
      explanation: json['funFact'] as String? ?? '',
      difficulty: _difficultyNames[(json['difficulty'] as int? ?? 1) - 1],
    );
  }

  static const _difficultyNames = ['easy', 'medium', 'hard'];

  String get correctAnswerText => options[correctAnswerIndex];

  /// Returns a copy with the same options in a new random order, keeping
  /// [correctAnswerIndex] pointing at the right answer.
  Question shuffledOptions(Random random) {
    final indexed = List<int>.generate(options.length, (i) => i)..shuffle(random);
    return Question(
      id: id,
      sectionId: sectionId,
      questionText: questionText,
      options: [for (final i in indexed) options[i]],
      correctAnswerIndex: indexed.indexOf(correctAnswerIndex),
      explanation: explanation,
      difficulty: difficulty,
      imagePath: imagePath,
    );
  }
}
