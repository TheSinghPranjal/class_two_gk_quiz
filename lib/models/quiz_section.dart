import 'package:flutter/material.dart';

/// A data-driven quiz section (subject). New sections can be added purely
/// as data — no quiz-engine or UI code needs to change.
@immutable
class QuizSection {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool enabled;

  const QuizSection({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.enabled = true,
  });
}
