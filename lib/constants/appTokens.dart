import 'package:flutter/material.dart';

// ========================
// COLORS
// COLOR--------#HEX-------BEST IF BG IS ------ BEST IF FORE IS
// Primary------#1B4332----White / Quaternary---Quaternary / White
// Secondary----#40916C----White----------------White
// Tertiary-----#FFB703----Primary--------------Primary / Black
// Quaternary---#FFF8D0----Primary--------------Primary / Secondary
// ========================
class AppColors {
  // FOREST & SUN THEME
  static const Color colPrimary = Color(0xFF1B4332); // Deep Forest
  static const Color colSecondary = Color(0xFF40916C); // Sage Green
  static const Color colTertiary = Color(0xFFFFB703); // Golden Sun
  static const Color colQuaternary = Color(0xFFFFF8D0); // Cream Mist

  // FOREGROUND - TEXT COLORS
  static const Color colOnPrimary = Color(0xFFFFF8D0);
  static const Color colOnSecondary = Color(0xFFFFFFFF); // white
  static const Color colOnTertiary = colPrimary;
  static const Color colOnQuaternary = colPrimary; // or colSecondary

  // BACKGROUND - BASE COLORS
  static const Color colBackground = Colors.white;
  static const Color colSurface = Color(0xFFF8F9FA);

  // COMMON
  static const Color colWhite = Color(0xFFFFFFFF);
  static const Color colRed = Color(0xFFFF0000);

  // Status Colors
  static const Color colSuccess = colSecondary;
  static const Color colOnSuccess = colQuaternary;
  static const Color colError = Color(0xFFD90429);
  static const Color colDisabled = Color(0xFFBDBDBD);
  static const Color colOnDisabled = Colors.black38;


}

// ========================
// TYPOGRAPHY
// ========================
class AppTypography{

  // LATIN FONTS
  static const String fontLogo = "Laila";
  static const String fontTitle = "Poppins"; // Abhaya Libre, Antic, Antic Didone, Arapey, Arima
  static const String fontSubtitle = "Poppins";
  static const String fontBody = "Poppins";
  static const String fontCaption = "Poppins";
  static const String fontLabel = "Poppins";
  static const String fontControls = "Poppins";
  static const String fontLink = "Poppins";

  //LOGO
  static const TextStyle logo = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: AppTypography.fontLogo,
    fontSize: 60,
    fontWeight: FontWeight.bold,
    height: 1.5,
    letterSpacing: 1,
  );

  // TITLE1
  static const TextStyle title1 = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: AppTypography.fontTitle,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.5,
    letterSpacing: 0.2,
  );

  // TITLE2
  static const TextStyle title2 = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontTitle,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
  );

  // SUBTITLE1
  static const TextStyle subtitle1 = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontSubtitle,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // SUBTITLE
  static const TextStyle subtitle2 = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontSubtitle,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  // BODY
  static const TextStyle body = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.6,
    letterSpacing: 0.0,
  );
  static const TextStyle bodyBold = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 1.6,
    letterSpacing: 0.0,
  );

  // CAPTION
  static const TextStyle caption = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontCaption,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.0,
  );
  // CAPTION
  static const TextStyle label = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontLabel,
    fontSize: 9,
    fontWeight: FontWeight.normal,
    height: 1.1,
    letterSpacing: 0.0,
  );

  // LINKS TEXT
  static const TextStyle link = TextStyle(
    color: AppColors.colSecondary,
    decoration: TextDecoration.underline,
    fontFamily: fontLink,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.0,
  );

  // BUTTON TEXT
  static const TextStyle controls = TextStyle(
    color: AppColors.colPrimary,
    fontFamily: fontControls,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,

  );
}

/////// DEPRECATE THIS
class AppFontSizes{
  static const double fontSizeLogo = 80;
  static const double fontSizeTitleBig = 22;
  static const double fontSizeTitle = 20;
  static const double fontSizeSubtitle = 16;
  static const double fontSizeBody = 14;
  static const double fontSizeCaption = 12;
}

// ========================
// OPACITY
// ========================
class AppAlpha {
  static const int alphaTransparent = 0;
  static const int alphaXLow = 25;    // For subtle "Glassmorphism" backgrounds
  static const int alphaLow = 75;   // For inactive icons or dividers
  static const int alphaMedium = 150;   // For secondary text/descriptions
  static const int alphaHigh = 220; // For high-readability overlays
  static const int alphaOpaque = 255;
}

// ========================
// SPACING
// ========================
class AppSizes {
  static const double sizeXXXSmall = 2.0;
  static const double sizeXXSmall = 4.0;
  static const double sizeXSmall = 8.0;
  static const double sizeSmall = 16.0;
  static const double sizeMedium = 24.0;
  static const double sizeLarge = 32.0;
  static const double sizeXLarge = 48.0;
  static const double sizeCircular = 999.0;

  // Screen-specific layout padding
  static const double screenEdge = 20.0;
  static const double bottomPanelPadding = 50.0;
}
// ========================
// ELEVATION
// ========================
class AppShadows {
  // Level 1: Subtle elevation (Buttons, Small Cards)
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: AppColors.colPrimary.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Level 2: Medium elevation (Modals, Bottom Panels)
  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: AppColors.colPrimary.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // Level 3: High elevation (Hero elements, Floating Action Buttons)
  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: AppColors.colPrimary.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  // Special: Colored Glow (For the Tertiary/Gold elements)
  static List<BoxShadow> shadowGold = [
    BoxShadow(
      color: AppColors.colTertiary.withOpacity(0.4),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 0),
    ),
  ];
}

// ========================
// MOTION
// ========================
class AppDurations {
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 500);
  static const Duration durationSlow = Duration(milliseconds: 1000);
  static const Duration durationXSlow = Duration(milliseconds: 2000);
  static const Duration durationXXSlow = Duration(milliseconds: 2500);
  static const Duration durationXXXSlow = Duration(milliseconds: 3000);
}

// ========================
// GAMEPLAY
// ========================

enum QuizLevel {
  beginner('Beginner', 'P0, P1'),
  hobbyist('Hobbyist', 'P0,P1,P2'),
  expert('Expert', 'P0,P1,P2,P3'),
  purist('Purist', 'P0, P1, P2, P3, P4');
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