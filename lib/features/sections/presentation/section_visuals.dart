import '../../../models/quiz_section.dart';

/// Presentation-only artwork for a section, kept in the UI layer so the
/// section data itself stays untouched.
extension SectionVisuals on QuizSection {
  String get emoji => _emojis[id] ?? '📚';
}

const _emojis = {
  'mathematics': '🔢',
  'english': '🔤',
  'science': '🔬',
  'general_knowledge': '🌍',
  'animals': '🦁',
  'birds_insects': '🦜',
  'fruits_veggies': '🍎',
  'my_body': '🖐️',
  'food_health': '🥛',
  'colours_shapes': '🔺',
  'numbers_time': '⏰',
  'family_home': '🏠',
  'helpers': '👮',
  'transport': '🚂',
  'nature_weather': '🌦️',
  'space': '🌙',
  'india': '🇮🇳',
  'festivals': '🪔',
  'sports_games': '⚽',
  'safety': '🚦',
};
