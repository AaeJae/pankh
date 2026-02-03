import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../screens/homescreen/homescreen.dart';
import '../screens/quizscreen/quizscreen.dart';
import 'uihelper.dart';
import 'package:pankh/constants/appTokens.dart';

class WidQuizHelper {
  /// DIFFICULTY PICKER
  static Future<String?> showDifficultyPicker(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: AppColors.colOnPrimary.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UiHelper.CustomText(text: "Select Difficulty", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeTitle, fontFamily: AppFonts.fontFamilyTitle),
                const SizedBox(height: 24),

                // Map through the enum values instead of hardcoding
                ...QuizLevel.values.map((level) {
                  return _buildDifficultyPill(
                    context,
                    level.displayText,    // "Beginner"
                    level.databaseValue, // "Common"
                    _getColorForLevel(level),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper to keep the picker clean
  static Color _getColorForLevel(QuizLevel level) {
    switch (level) {
      case QuizLevel.beginner:
        return Colors.greenAccent;
      case QuizLevel.intermediate:
        return Colors.orangeAccent;
      case QuizLevel.expert:
        return Colors.redAccent;
    }
  }

  static Widget _buildDifficultyPill(BuildContext context, String label, String firebaseValue, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => Navigator.pop(context, firebaseValue),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            //border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
          ),
          child: Center(
            child: UiHelper.CustomText(text: label, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle)
          ),
        ),
      ),
    );
  }
  /// END DIFFICULTY PICKER

  /// 1. Unified Glassmorphic Chip (Used for score, timer, and hints)
  static Widget infoChip(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: UiHelper.CustomText(text: text, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle)
    );
  }

  /// 2. Branded Progress Bar
  static Widget progressBar(int current, int total) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: total == 0 ? 0 : current / total,
        minHeight: 8,
        backgroundColor: Colors.white.withOpacity(0.2),
        color: Colors.white,
      ),
    );
  }

  /// 3. Media Wrapper (The Stage)
  static Widget buildMediaWrapper(
      {required Widget mediaWidget, required bool isQuizStarted}) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: isQuizStarted ? mediaWidget : const SizedBox.shrink(),
        ),
      ),
    );
  }

  /// 4. Audio UI (Visualizer + Replay)
  static Widget buildAudioUI({
    required PlayerController controller,
    required VoidCallback onReplay,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        UiHelper.CustomText(text: "Listen to the bird's audio", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle),
        const SizedBox(height: 30),

        birdAudioVisualizer(controller: controller, waveColor: Colors.white),
        const SizedBox(height: 10),
      ],
    );
  }

  static Future<String?> showResults(BuildContext context, int correct, int total) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevents accidental closing
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.colPrimary.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: UiHelper.CustomText(
              text: "Quiz finished!",
              color: AppColors.colWhite,
              fontSize: AppFontSizes.fontSizeTitle,
              fontFamily: AppFonts.fontFamilyTitle
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the score
            UiHelper.CustomText(
                text: "$correct / $total",
                color: AppColors.colOnPrimary,
                fontSize: 40,
                fontWeight: FontWeight.bold
            ),
            const SizedBox(height: 24),

            // These pills pop the dialog and return the string to the 'await'
            _buildPill(context, "Play Again", "restart"),
            _buildPill(context, "Quit to Home", "exit"),
          ],
        ),
      ),
    );
  }

  static Widget _buildPill(BuildContext context, String label, String targetPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => Navigator.pop(context, targetPage),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
              child: UiHelper.CustomText(text: label, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle)
          ),
        ),
      ),
    );
  }
  // --- INTERNAL HELPERS ---

  static Widget birdAudioVisualizer(
      {required PlayerController controller, required Color waveColor}) {
    return AudioFileWaveforms(
      size: const Size(300, 100),
      playerController: controller,
      enableSeekGesture: true,
      waveformType: WaveformType.fitWidth,
      playerWaveStyle: PlayerWaveStyle(
        fixedWaveColor: waveColor.withOpacity(0.2),
        liveWaveColor: waveColor,
        spacing: 3, // customize
        waveThickness: 2, // customize
        scaleFactor: 300, // customize
        showSeekLine: true,
      ),
    );
  }

  static Widget hintCarousel({
    required int currentIndex,
    required int totalHints,
    required VoidCallback onPrevious,
    required VoidCallback onNext
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hide or dim the left button if on the first hint
          Opacity(
            opacity: currentIndex == 0 ? 0.3 : 1.0,
            child: _navButton(Icons.chevron_left, currentIndex == 0 ? () {} : onPrevious),
          ),

          // Dynamic counter
          infoChip(
              "Hint ${currentIndex + 1} / $totalHints",
              color: AppColors.colSecondary.withOpacity(0.7)
          ),

          // Hide or dim the right button if on the last hint
          Opacity(
            opacity: currentIndex == totalHints - 1 ? 0.3 : 1.0,
            child: _navButton(Icons.chevron_right, currentIndex == totalHints - 1 ? () {} : onNext),
          ),
        ],
      ),
    );
  }

  static Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.colPrimary.withOpacity(0.5), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.colOnPrimary, size: 28),

      ),
    );
  }

  static Widget hintOverlay(String hintText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
        ),
      ),
      child: UiHelper.CustomText(text: hintText, textAlign: TextAlign.center, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle),
    );
  }

  static Widget buildBigCounter(int countdown) {
    return Center(
      child: Text("$countdown", style: const TextStyle(
          fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  static String formatTime(Duration d) {
    // Ensure we don't show negative time if the timer overshoots
    if (d.isNegative) return "00:00";

    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  static Path drawFeather(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Start at the bottom (the "quill" point)
    path.moveTo(width * 0.5, height);

    // Draw the left side with a slight outward curve
    path.quadraticBezierTo(
      0, height * 0.5,           // Control point (bulge)
      width * 0.5, 0,            // Top point
    );

    // Draw the right side with a slightly different curve for asymmetry
    path.quadraticBezierTo(
      width * 1.2, height * 0.5, // Control point
      width * 0.5, height,       // Back to bottom
    );

    path.close();
    return path;
  }
}