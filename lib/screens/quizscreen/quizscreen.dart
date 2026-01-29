import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/constants/appTokens.dart';
import 'package:pankh/models/modBird.dart';
import 'package:pankh/services/serBird.dart';
import 'package:pankh/widgets/widQuizHelper.dart';
import 'package:pankh/widgets/widQuizOptions.dart';
import 'package:pankh/widgets/uihelper.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onQuit; // Add this
  const QuizScreen({super.key, required this.onQuit});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  final BirdService _birdService = BirdService();
  List<BirdModel> birds = [];
  bool isLoading = true;
  int currentIndex = 0;
  int correctCount = 0;

  int countdown = 3;
  bool isQuizStarted = false;
  Duration quizDuration = const Duration(minutes: 2);
  Timer? _countdownTimer;
  Timer? _quizTimer;

  late AnimationController _bgRotationController;

  @override
  void initState() {
    super.initState();
    _bgRotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    _initializeQuiz();
  }

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

  void _handleAnswer(String selectedName) {
    if (selectedName == birds[currentIndex].birdName) {
      WidQuizHelper.incrementScore();
      correctCount++; // <-- increment correct answers
    }
    if (currentIndex < birds.length - 1) {
      setState(() => currentIndex++);
    } else {
      _finishQuiz();
    }
  }


  void _finishQuiz() {
    _quizTimer?.cancel();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _quizTimer?.cancel();
    _bgRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final currentBird = birds[currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [AppColors.colTertiary, AppColors.colSecondary],
          ),
        ),
        child: Column(
          children: [
            // 1. DYNAMIC TOP SPACING (Clears your custom Header)
            SizedBox(height: 110),

            // 2. QUIZ HEADER (Close button + Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.colSecondary, size: 30),
                    onPressed: () => _showExitConfirmation(),
                  ),
                  const Spacer(),
                  UiHelper.CustomText(
                      text: "Pankh Quiz",
                      fontFamily: AppFonts.fontFamilyLogo,
                      fontSize: AppFontSizes.fontSizeTitleBig,
                      color: AppColors.colSecondary,
                      fontWeight: FontWeight.bold
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // 3. PROGRESS BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildInfoChip("${correctCount} / ${birds.length}"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (currentIndex) / birds.length,
                          minHeight: 8,
                          backgroundColor: AppColors.colWhite.withOpacity(0.2),
                          color: AppColors.colSecondary,
                        ),
                      ),
                    ),
                  ),
                  _buildInfoChip(_formatDuration(quizDuration)),
                ],
              ),
            ),

            // 4. BIRD IMAGE BOX (Slightly smaller to prevent overflow)
            WidQuizHelper.buildMediaWrapper(
              isQuizStarted: isQuizStarted,
              totalQuestions: birds.length,
              remainingTime: quizDuration,
              mediaWidget: _buildMediaContent(currentBird),
            ),

            // 5. THE 20PX GAP
            const SizedBox(height: 20),

            // 6. OPTIONS AREA (Scrollable to prevent "Yellow Stripe" error)
            Expanded(
              child: isQuizStarted
                  ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120), // Large bottom padding for Nav Bar
                child: WidQuizOptions(
                  options: birds.map((b) => {
                    "name": b.birdName,
                    "image": b.birdImageUrls.isNotEmpty ? b.birdImageUrls[0] : ""
                  }).toList(),
                  size: QuizOptionSize.small,
                  onOptionSelected: _handleAnswer,
                ),
              )
                  : Center(child: WidQuizHelper.buildBigCounter(countdown)),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS ---
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.colWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.colWhite.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.colWhite, fontSize: 13),
      ),
    );
  }

  Widget _buildMediaContent(BirdModel bird) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 6),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          bird.birdImageUrls.isNotEmpty ? bird.birdImageUrls[0] : "",
          height: 220, // Reduced height to fit options better
          width: 220,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _showExitConfirmation() async {
    bool? quit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Quit Quiz?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Your progress will be lost. Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("STAY")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("QUIT", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (quit == true && mounted) {
      widget.onQuit(); // This triggers the index switch in HomeScreen
    }
  }
}