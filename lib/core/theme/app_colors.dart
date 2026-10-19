import 'package:flutter/material.dart';

/// Central colour palette for the whole app. No widget should hard-code a
/// colour value directly — add it here first.
abstract final class AppColors {
  static const Color background = Color(0xFFFFF8E7);
  static const Color surface = Colors.white;
  static const Color ink = Color(0xFF4A3B2A);
  static const Color inkMuted = Color(0xFF8A7A68);
  static const Color inkDeep = Color(0xFF2E1A0B);
  static const Color woodInk = Color(0xFF55361A);
  static const Color hintInk = Color(0xFF82455E);
  static const Color quizCream = Color(0xFFFCF3DF);
  static const Color divider = Color(0xFFE1D6C0);

  // "Leave the quiz?" dialog.
  static const Color dialogCream = Color(0xFFF7EBDD);
  static const Color dialogBody = Color(0xFF584235);
  static const Color keepPlayingTop = Color(0xFFFDEAE9);
  static const Color keepPlayingBottom = Color(0xFFF9D2D2);
  static const Color keepPlayingDepth = Color(0xFFF0B3C0);
  static const Color keepPlayingText = Color(0xFFC8095B);
  static const Color leaveTop = Color(0xFFF25B94);
  static const Color leaveBottom = Color(0xFFE6337A);
  static const Color leaveDepth = Color(0xFFCB0D5D);

  static const Color primary = Color(0xFFFF7EB6);
  static const Color primaryDark = Color(0xFFE85FA0);

  static const Color success = Color(0xFF4CAF6D);
  static const Color successDark = Color(0xFF389156);
  static const Color error = Color(0xFFEF7A6C);
  static const Color errorDark = Color(0xFFD65E50);

  static const Color star = Color(0xFFFFC93C);
  static const Color starDark = Color(0xFFE0A800);

  // Claymorphism scene palette (section detail screen).
  static const Color clayCream = Color(0xFFFEF4E0);
  static const Color wood = Color(0xFFB8673A);
  static const Color woodLight = Color(0xFFE2A66E);
  static const Color leaf = Color(0xFF7CC26B);
  static const Color leafDark = Color(0xFF4E9A45);
  static const Color hill = Color(0xFFC9E4A3);
  static const Color sand = Color(0xFFF3D9A6);
  static const Color cloud = Color(0xFFE8F0FF);
  static const Color rock = Color(0xFFBDB6AE);

  // Play-mode card colours.
  static const Color modePractice = Color(0xFFFC7823);
  static const Color modeQuiz = Color(0xFFFAAF12);
  static const Color modeBook = Color(0xFFFD4A7E);

  static const List<Color> blobs = [
    Color(0xFFFFD6E8),
    Color(0xFFD6F5E8),
    Color(0xFFD6E8FF),
    Color(0xFFFFF0C2),
  ];

  // Section colours — one named constant per section so they stay usable in
  // const contexts (a `const` list can't be indexed at compile time).
  static const Color sectionMath = Color(0xFF38B6FF);
  static const Color sectionEnglish = Color(0xFF9C6BFF);
  static const Color sectionScience = Color(0xFF14B8A6);
  static const Color sectionGeneralKnowledge = Color(0xFFFF9933);
  static const Color sectionAnimals = Color(0xFFFF8A3D);
  static const Color sectionBirdsInsects = Color(0xFF8BC34A);
  static const Color sectionFruitsVeggies = Color(0xFFFF5A5F);
  static const Color sectionMyBody = Color(0xFFFF7EB6);
  static const Color sectionFoodHealth = Color(0xFFFFB300);
  static const Color sectionColoursShapes = Color(0xFFAB47BC);
  static const Color sectionNumbersTime = Color(0xFF3F7BFF);
  static const Color sectionFamilyHome = Color(0xFFF06292);
  static const Color sectionHelpers = Color(0xFF5C6BC0);
  static const Color sectionTransport = Color(0xFF00ACC1);
  static const Color sectionNatureWeather = Color(0xFF22C55E);
  static const Color sectionSpace = Color(0xFF5B5BD6);
  static const Color sectionIndia = Color(0xFFFF7043);
  static const Color sectionFestivals = Color(0xFFFFD23F);
  static const Color sectionSportsGames = Color(0xFF43A047);
  static const Color sectionSafety = Color(0xFFE53935);

  /// Darker shade used for the chunky "candy button" bottom shadow.
  static Color darken(Color color, [double amount = 0.18]) {
    final hsl = HSLColor.fromColor(color);
    final l = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }

  /// Lighter shade used for clay highlights.
  static Color lighten(Color color, [double amount = 0.12]) {
    final hsl = HSLColor.fromColor(color);
    final l = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }
}
