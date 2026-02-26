import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pankh/models/mod_bird.dart';
import 'package:pankh/constants/appDesignSystem.dart';

class QuizController {
  // State
  List<ModBird> birds = [];
  int currentIndex = 0;
  int correctCount = 0;
  bool isQuizStarted = false;
  int countdown = 3;

  // Timers
  Timer? countdownTimer;
  Timer? quizTimer;
  final ValueNotifier<Duration> timerNotifier;

  QuizController({required int durationMins})
      : timerNotifier = ValueNotifier(Duration(minutes: durationMins));

  // --- Logic Functions ---

  bool isListEmpty() => birds.isEmpty;

  void resetGame(int durationMins) {
    currentIndex = 0;
    correctCount = 0;
    isQuizStarted = false;
    countdown = 3;
    timerNotifier.value = Duration(minutes: durationMins);
    countdownTimer?.cancel();
    quizTimer?.cancel();
  }

  void handleCorrectAnswer() {
    correctCount++;
  }

  bool proceedToNext() {
    if (currentIndex < birds.length - 1) {
      currentIndex++;
      return true; // Has next
    }
    return false; // Finished
  }

  List<Map<String, String>> generateOptions() {
    final correctBird = birds[currentIndex];
    List<ModBird> others = birds.where((b) => b.birdName != correctBird.birdName).toList();
    others.shuffle();
    List<ModBird> quizOptions = [correctBird, ...others.take(3)]..shuffle();

    return quizOptions.map((b) => {
      "name": b.birdName,
      "image": b.featuredImage.imageURL,
    }).toList();
  }
}