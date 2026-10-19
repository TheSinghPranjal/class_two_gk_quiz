import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Central typography for the whole app. Headings use the playful rounded
/// "Baloo 2" font; body copy uses the friendly "Nunito" font.
abstract final class AppTextStyles {
  static TextStyle heading({
    double fontSize = 28,
    Color color = AppColors.ink,
    FontWeight weight = FontWeight.w700,
  }) => GoogleFonts.baloo2(
    fontSize: fontSize,
    color: color,
    fontWeight: weight,
    height: 1.15,
  );

  static TextStyle body({
    double fontSize = 16,
    Color color = AppColors.ink,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.nunito(
    fontSize: fontSize,
    color: color,
    fontWeight: weight,
    height: 1.3,
  );

  static TextStyle button({double fontSize = 18, Color color = Colors.white}) =>
      GoogleFonts.baloo2(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w600,
      );
}
