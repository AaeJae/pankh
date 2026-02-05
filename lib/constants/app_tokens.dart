import 'package:flutter/material.dart';

// ========================
// COLORS
// ========================
class AppColors {
  // GREEN THEME
  static const Color colPrimary = Color(0xFF1B4332);
  static const Color colOnPrimary = Color(0xFFF8F9FA);
  static const Color colSecondary = Color(0xFF3B633D);
  static const Color colOnSecondary = Color(0xFF6750A4);
  static const Color colTertiary = Color(0xFFFFF8D0);
  static const Color colOnTertiary = Color(0xFFFCBF49);

  // COMMON
  static const Color colWhite = Color(0xFFFFFFFF);
  static const Color colBlack = Color(0xFF000000);
  static const Color colGreen = Color(0xFF00FF00);
  static const Color colRed = Color(0xFFFF0000);


}

// ========================
// FONTS
// ========================
class AppFonts{
  // ENGLISH
  static const String fontFamilyLogo = "Laila";
  static const String fontFamilyTitle = "DM Serif Display";
  static const String fontFamilySubtitle = "DM Serif Display";
  static const String fontFamilyBody = "KantumruyPro";
  static const String fontFamilyCaption = "KantumruyPro";

  // INDIC
  static const String fontFamilyDevnagari = "KantumruyPro";
  static const String fontFamilyGujarati = "KantumruyPro";
  static const String fontFamilyTelugu = "KantumruyPro";
  static const String fontFamilyTamil = "KantumruyPro";
  static const String fontFamilyKannada = "KantumruyPro";
}
class AppFontSizes{
  static const double fontSizeLogo = 80;
  static const double fontSizeTitleBig = 22;
  static const double fontSizeTitle = 20;
  static const double fontSizeSubtitle = 16;
  static const double fontSizeBody = 14;
  static const double fontSizeCaption = 12;
}

// ========================
// BORDER RADIUS
// ========================
class AppBorderRadius {
  static const int bordRadiusXSmall = 8;
  static const int bordRadiusSmall = 16;
  static const int bordRadiusMedium = 30;
  static const int bordRadiusLarge = 50;
  static const int bordRadiusCircular = 9999;
}





// ========================
// GAMEPLAY
// ========================

enum QuestionType {
  image("small"),
  audio("big");

  final String optionSize;

  const QuestionType(this.optionSize);
}

enum QuizLevel {
  beginner('Beginner', 'Common'),
  intermediate('Intermediate', 'Occasional'),
  expert('Expert', 'Rare');

  final String displayText;   // What the user sees
  final String databaseValue; // What Firebase searches for

  const QuizLevel(this.displayText, this.databaseValue);
}


