import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sections_data.dart';
import '../models/question.dart';

/// Question data-access layer. Questions live in bundled JSON assets
/// (`assets/questions/<sectionId>.json`, one file per section) and are loaded
/// once at startup via [load]; swapping this for an API/Firebase-backed
/// implementation later requires no changes to the quiz engine or UI.
class QuestionRepository {
  final List<Question> _questions;

  QuestionRepository(List<Question> questions) : _questions = List<Question>.unmodifiable(questions);

  /// Reads every section's JSON file from [bundle].
  static Future<QuestionRepository> load([AssetBundle? bundle]) async {
    final source = bundle ?? rootBundle;
    final all = <Question>[];
    for (final section in kSections) {
      final raw = await source.loadString('assets/questions/${section.id}.json');
      for (final item in jsonDecode(raw) as List<dynamic>) {
        all.add(Question.fromJson(item as Map<String, dynamic>));
      }
    }
    return QuestionRepository(all);
  }

  List<Question> _all() => _questions;

  /// Returns every question belonging to [sectionIds]. An empty list means
  /// "random / all sections".
  List<Question> getForSections(List<String> sectionIds) {
    if (sectionIds.isEmpty) return _all();
    return _all().where((q) => sectionIds.contains(q.sectionId)).toList();
  }

  int countForSection(String sectionId) => _all().where((q) => q.sectionId == sectionId).length;

  Question? findById(String id) {
    for (final q in _all()) {
      if (q.id == id) return q;
    }
    return null;
  }
}

/// Loads the bundled question JSON once. [HomeScreen] waits on this before
/// showing any section, so everything reachable from it can use
/// [questionRepositoryProvider] synchronously.
final questionBankProvider = FutureProvider<QuestionRepository>((ref) => QuestionRepository.load());

final questionRepositoryProvider = Provider<QuestionRepository>(
  (ref) => ref.watch(questionBankProvider).requireValue,
);
