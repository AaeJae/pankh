import 'package:flutter/material.dart';
import 'uihelper.dart'; // Ensure this points to your CustomText/CustomSvg
import 'package:pankh/constants/appTokens.dart';

class WidQuizHelper {
  // ==========================================
  // 1. GLOBAL STATE (PERSISTENT SCORE)
  // ==========================================
  static int correctCount = 0;

  static void incrementScore() {
    correctCount++;
  }

  static void resetScore() {
    correctCount = 0;
  }

  // ==========================================
  // 2. COMMON LAYOUT (THE WRAPPER)
  // ==========================================

  /// This wraps your Image or Sound Player and pins the chips on top.
  /// Used in the "Quiz Controller" to keep positioning consistent.
  static Widget buildMediaWrapper({
    required Widget mediaWidget,
    required int totalQuestions,
    required Duration remainingTime,
    required bool isQuizStarted,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // The Box that holds the Image or Sound Player
            SizedBox(
              height: 300,
              width: 300,
              child: isQuizStarted
                  ? mediaWidget
                  : const SizedBox.shrink(), // Hidden during countdown
            ),

            // Correct Answer Tracker (Left Chip)
            Positioned(
              top: -70,
              left: 20,
              child: infoChip("$correctCount / $totalQuestions"),
            ),

            // Countdown Timer (Right Chip)
            Positioned(
              top: -70,
              right: 20,
              child: infoChip(formatTime(remainingTime)),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 3. UI COMPONENTS
  // ==========================================

  /// The Info Chips used for Timer and Progress
  static Widget infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(50),
      ),
      child: UiHelper.CustomText(
        text: text,
        color: AppColors.colPurple,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: "KantumruyPro",
      ),
    );
  }

  /// The Big Countdown (3, 2, 1) displayed before the quiz starts
  static Widget buildBigCounter(int countdown) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          color: Color(0xFFFDE7AA), // Pale yellow circle
          shape: BoxShape.circle,
        ),
        child: Text(
          "$countdown",
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B4FA9),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. UTILITIES
  // ==========================================

  /// Formats Duration to MM:SS
  static String formatTime(Duration d) {
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}