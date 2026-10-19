import 'package:flutter/foundation.dart';

import 'quiz_enums.dart';

@immutable
class QuizResult {
  final String id;
  final QuizMode mode;
  final List<String> sectionIds;
  final int score;
  final int correct;
  final int wrong;
  final int skipped;
  final int totalAnswered;
  final int durationSeconds;
  final DateTime timestamp;

  const QuizResult({
    required this.id,
    required this.mode,
    required this.sectionIds,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.totalAnswered,
    required this.durationSeconds,
    required this.timestamp,
  });

  double get accuracy => totalAnswered == 0 ? 0 : (correct / totalAnswered) * 100;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mode': mode.name,
        'sectionIds': sectionIds,
        'score': score,
        'correct': correct,
        'wrong': wrong,
        'skipped': skipped,
        'totalAnswered': totalAnswered,
        'durationSeconds': durationSeconds,
        'timestamp': timestamp.toIso8601String(),
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        id: json['id'] as String,
        mode: QuizMode.values.byName(json['mode'] as String),
        sectionIds: List<String>.from(json['sectionIds'] as List),
        score: json['score'] as int,
        correct: json['correct'] as int,
        wrong: json['wrong'] as int,
        skipped: json['skipped'] as int,
        totalAnswered: json['totalAnswered'] as int,
        durationSeconds: json['durationSeconds'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
