import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:pankh/widgets/wid_dialog.dart';
import 'wid_uihelper.dart';
import 'package:pankh/constants/app_tokens.dart';

class WidQuizHelper {
  /// DIFFICULTY PICKER
  static Future<String?> showDifficultyPicker(BuildContext context) {
    return WidDialog.customDialog(
      context,
      "Select Difficulty",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Map through enum values dynamically
          for (var level in QuizLevel.values)
            WidDialog.customDialogPill(
              context,
              level.displayText,    // e.g. "Beginner"
              level.databaseValue,  // e.g. "Common"
            ),
        ],
      ),
      // No extra pills here, just the difficulty options
      [],
    );
  }
  /// END DIFFICULTY PICKER

  /// 1. Unified Glassmorphic Chip (Used for score, timer, and hints)
  static Widget infoChip(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha:0.1)),
      ),
      child: UiHelper.customText(text: text, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle)
    );
  }

  /// PROGRESS BAR
  static Widget progressBar(int current, int total) {
    // Ensure we don't exceed 1.0 if current increments at the very end
    double progressValue = total == 0 ? 0 : (current + 1) / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        // clamp ensures the value stays between 0.0 and 1.0
        value: progressValue.clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: Colors.white.withValues(alpha:0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
          color: Colors.black.withValues(alpha:0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha:0.1)),
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
        UiHelper.customText(text: "Listen to the bird's audio", color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle),
        const SizedBox(height: 30),

        birdAudioVisualizer(controller: controller, waveColor: Colors.white),
        const SizedBox(height: 10),
      ],
    );
  }

  static Future<String?> showResults(
      BuildContext context,
      int correct,
      int total,
      bool isGuest,
      ) {
    return WidDialog.customDialog(
      context,
      "Quiz Finished!",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UiHelper.customText(
            text: isGuest ? "Waah!\n+100XP awarded!" : "Waah!\n",
            textAlign: TextAlign.center,
            color: AppColors.colOnPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 30),
          UiHelper.customText(
            text: isGuest ? "Login to claim!" : "",
            textAlign: TextAlign.center,
            color: AppColors.colOnPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

        ],
      ),
      // Pills: label + action
      [
        if (isGuest) DialogPill(label: "Login with Google", action: "login"),
        DialogPill(label: "Play Again", action: "restart"),
      ],
      canClose: true,
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
        fixedWaveColor: waveColor.withValues(alpha:0.2),
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
              color: AppColors.colSecondary.withValues(alpha:0.7)
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
            color: AppColors.colPrimary.withValues(alpha:0.5), shape: BoxShape.circle),
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
          colors: [Colors.transparent, Colors.black.withValues(alpha:0.85)],
        ),
      ),
      child: UiHelper.customText(text: hintText, textAlign: TextAlign.center, color: AppColors.colWhite, fontSize: AppFontSizes.fontSizeSubtitle, fontFamily: AppFonts.fontFamilySubtitle),
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