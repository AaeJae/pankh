import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/models/modBird.dart';
import 'package:pankh/services/serBird.dart';
import 'package:pankh/widgets/widQuizHelper.dart';
import 'package:pankh/widgets/widQuizOptions.dart';
import 'package:pankh/widgets/widHeader.dart';
import 'package:pankh/widgets/uihelper.dart';
import 'package:pankh/constants/appTokens.dart';

class QuizControllerScreen extends StatefulWidget {
  const QuizControllerScreen({super.key});

  @override
  State<QuizControllerScreen> createState() => _QuizControllerScreenState();
}

class _QuizControllerScreenState extends State<QuizControllerScreen> {
  // --- Data & Loading State ---
  final BirdService _birdService = BirdService();
  List<BirdModel> birds = [];
  bool isLoading = true;
  int currentIndex = 0;

  // --- Timer & Quiz State ---
  int countdown = 3;
  bool isQuizStarted = false;
  Duration quizDuration = const Duration(minutes: 2);
  Timer? _countdownTimer;
  Timer? _quizTimer;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  /// 1. Fetch data and Reset Global Score
  void _initializeQuiz() async {
    WidQuizHelper.resetScore();
    List<BirdModel> fetchedBirds = await _birdService.getAllBirds();

    if (mounted) {
      setState(() {
        birds = fetchedBirds;
        isLoading = false;
      });

      if (birds.isNotEmpty) {
        _startInitialCountdown();
      }
    }
  }

  /// 2. The 3-2-1 Countdown
  void _startInitialCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        setState(() => isQuizStarted = true);
        _startQuizTimer();
      }
    });
  }

  /// 3. The Main Quiz Timer
  void _startQuizTimer() {
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (quizDuration.inSeconds > 0) {
        setState(() => quizDuration -= const Duration(seconds: 1));
      } else {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  /// 4. Answer Handling Logic
  void _handleAnswer(String selectedName) {
    // Check if correct against the current bird in the list
    if (selectedName == birds[currentIndex].birdName) {
      WidQuizHelper.incrementScore();
      debugPrint("Correct! Global Score: ${WidQuizHelper.correctCount}");
    } else {
      debugPrint("Wrong!");
    }

    // Advance to next or finish
    if (currentIndex < birds.length - 1) {
      setState(() => currentIndex++);
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _quizTimer?.cancel();
    debugPrint("Quiz Finished! Final Score: ${WidQuizHelper.correctCount}");
    // TODO: Navigator.push to a Results Screen
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _quizTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Loading State
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.colWhite,
        body: Center(child: CircularProgressIndicator(color: AppColors.colPurple)),
      );
    }

    // Empty State
    if (birds.isEmpty) {
      return const Scaffold(body: Center(child: Text("No birds found in database.")));
    }

    // Current Question Data
    final currentBird = birds[currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const WidHeader(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background UI
          Positioned(
            top: 0, left: 0, right: 0,
            child: UiHelper.CustomSvg(
              img: "svgBgGreenPlains.svg",
              height: screenHeight * 0.5,
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: (screenHeight * 0.25)),

                // MEDIA AREA: Wrapped by Helper for Chip Positioning
                WidQuizHelper.buildMediaWrapper(
                  isQuizStarted: isQuizStarted,
                  totalQuestions: birds.length,
                  remainingTime: quizDuration,
                  mediaWidget: _buildMediaContent(currentBird),
                ),

                // INTERACTION AREA: Options or Countdown
                SizedBox(
                  height: screenHeight * 0.55,
                  child: isQuizStarted
                      ? WidQuizOptions(
                    options: birds.map((b) => {
                      "name": b.birdName,
                      "image": b.birdImageUrls.isNotEmpty ? b.birdImageUrls[0] : ""
                    }).toList(),
                    size: QuizOptionSize.small,
                    onOptionSelected: _handleAnswer,
                  )
                      : WidQuizHelper.buildBigCounter(countdown),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Media Switcher: Easily expandable for Sound Quizzes later
  Widget _buildMediaContent(BirdModel bird) {
    // Current logic: Image reveal
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        bird.birdImageUrls.isNotEmpty ? bird.birdImageUrls[0] : "",
        height: 300,
        width: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100, color: Colors.white),
      ),
    );
  }
}