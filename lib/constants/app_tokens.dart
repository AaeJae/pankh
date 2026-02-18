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
  beginner('Beginner', 'P0, P1'),
  intermediate('Intermediate', 'P2, P3'),
  expert('Expert', 'P4');
  final String displayText;   // What the user sees
  final String databaseValue; // What Firebase searches for
  const QuizLevel(this.displayText, this.databaseValue);
}


/////////////////////// SHOULD IDEALLY REPLACE WITH HOTSPOTSBIRDMAPPING IN FIREBASE from MONGODB
enum SupportedCity {
  mumbai(
    id: "IN-MH-MS",
    name: "Mumbai",
    boundingBox: "72.74,19.35,73.20,18.88",
  ),
  thane(
    id: "IN-MH-TH",
    name: "Thane",
    boundingBox: "72.90,19.33,73.10,19.15",
  );

  // Members are final and initialized via constructor
  final String id;
  final String name;
  final String boundingBox;

  const SupportedCity({
    required this.id,
    required this.name,
    required this.boundingBox,
  });

  // Helper to get all city names for the search query
  static String get allNames => SupportedCity.values.map((c) => c.name).join(" ");
}



// ColoredBox(
// color: Colors.blue,
// child: SizedBox(
// width: 100,
// height: 100,
// child: const Text("Sized and Colored"),
// ),
// ),