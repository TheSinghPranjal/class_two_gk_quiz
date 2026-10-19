import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/sections_data.dart';
import '../../../models/quiz_section.dart';

final sectionsProvider = Provider<List<QuizSection>>((ref) {
  return kSections.where((s) => s.enabled).toList();
});
