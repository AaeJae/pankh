import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

// Internal Project Imports
import 'package:pankh/constants/appDesignSystem.dart';
import 'package:pankh/models/mod_bird.dart';
import 'package:pankh/widgets/widQuizHelper.dart';
import 'package:pankh/widgets/widQuizOptionHelper.dart';
import '../../services/ser_auth.dart';
import 'package:pankh/services/ser_user.dart';
import '../../services/ser_bird.dart';
import '../../widgets/widDialog.dart';

class QuizScreen extends StatefulWidget {
  final VoidCallback onQuit;
  final String difficulty;
  const QuizScreen({super.key, required this.onQuit, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // --- Services & Controllers ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  late PlayerController _waveformController;
  late ConfettiController _confettiController;

  // --- State Variables (STRICTLY PRESERVED) ---
  List<ModBird> birds = [];
  bool isLoading = true;
  int currentIndex = 0;
  int currentHintIndex = 0;
  int correctCount = 0;
  bool _isWrong = false;
  int countdown = 3;
  int quizDurationMins = 2;
  bool isQuizStarted = false;
  QuestionType currentType = QuestionType.image;
  List<Map<String, String>> _currentQuestionOptions = [];
  List<String> hints = [];

  // --- Timers & Notifiers (STRICTLY PRESERVED) ---
  late final ValueNotifier<Duration> _timerNotifier = ValueNotifier(Duration(minutes: quizDurationMins));
  Timer? _countdownTimer;
  Timer? _quizTimer;

  @override
  void initState() {
    super.initState();
    _waveformController = PlayerController();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _initializeQuiz();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _quizTimer?.cancel();
    _timerNotifier.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _waveformController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // ==========================================
  // LOGIC & STATE MANAGEMENT (ORIGINAL)
  // ==========================================

  Future<void> _initializeQuiz() async {
    correctCount = 0;
    if (mounted) {
      setState(() => isLoading = true);
      try {
        List<String> difficultyList = widget.difficulty.split(',').map((e) => e.trim()).toList();
        final data = await SerBird.getBirds(
            limitRows: 10,
            filterColumn: "rank",
            filterValue: difficultyList
        );
        debugPrint("data: ${data.length}, difficultyList: ${difficultyList}");

        if (mounted) {
          setState(() {
            birds = data;
            isLoading = false;
          });

          // ONLY start the countdown if we actually found birds
          if (birds.isNotEmpty) {
            _startInitialCountdown();
          }
        }
      } catch (e) {
        debugPrint("Init Error: $e");
        if (mounted) setState(() => isLoading = false);
      }
      if (birds.isNotEmpty) _startInitialCountdown();
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
        _prepareQuestionMedia();
      }
    });
  }

  void _startQuizTimer() {
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerNotifier.value.inSeconds > 0) {
        _timerNotifier.value -= const Duration(seconds: 1);
      } else {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  void _prepareQuestionMedia() {
    final bird = birds[currentIndex];
    hints = [
      "Habitat: ${bird.birdInfo.habitat}",
      "Order: ${bird.birdInfo.order}",
      "Hindi name: ${bird.hindiNames}",
      "Marathi name: ${bird.marathiNames}",
      "Lore: ${bird.lore}",
    ];
    _currentQuestionOptions = _generateOptions();
    if (currentType == QuestionType.audio && birds.isNotEmpty) {
      _playBirdSound(bird.birdAudios[0].audioURL);
    }
  }

  Future<void> _playBirdSound(String url) async {
    if (url.isEmpty) return;
    try {
      await _waveformController.stopPlayer();
      String localPath = await _downloadAndGetPath(url);
      await _waveformController.preparePlayer(path: localPath, shouldExtractWaveform: true);
      await _waveformController.startPlayer();
    } catch (e) {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  void _handleAnswer(String selectedName) {
    _waveformController.stopPlayer();
    if (selectedName == birds[currentIndex].birdName) {
      _confettiController.play();
      setState(() => correctCount++);
      Future.delayed(const Duration(milliseconds: 600), () => _proceedToNext());
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _isWrong = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isWrong = false);
          _proceedToNext();
        }
      });
    }
  }

  void _proceedToNext() {
    if (currentIndex < birds.length - 1) {
      setState(() {
        currentIndex++;
        currentHintIndex = 0;
        currentType = QuestionType.values[Random().nextInt(QuestionType.values.length)];
      });
      _prepareQuestionMedia();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    _quizTimer?.cancel();
    _waveformController.stopPlayer();
    final String? action = await WidDialog.showResults(context, correctCount, birds.length, SerUser.isGuest);
    if (action == null) {
      widget.onQuit();
      return;
    }
    switch (action) {
      case "login":
        WidDialog.showDialogLoading(context);
        User? user = await SerAuth().signInWithGoogle(pendingXP: 100);
        Navigator.pop(context);
        if (user != null) widget.onQuit();
        break;
      case "restart":
        _resetGameState();
        _initializeQuiz();
        break;
      default:
        _resetGameState();
        _initializeQuiz();
        break;
    }
  }

  void _resetGameState() {
    setState(() {
      currentIndex = 0;
      correctCount = 0;
      currentHintIndex = 0;
      countdown = 3;
      isQuizStarted = false;
      _timerNotifier.value = Duration(minutes: quizDurationMins);
    });
  }

  // ==========================================
  // UI BUILDERS (DESIGN SYSTEM APPLIED)
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.colPrimary,
        body: Center(child: CircularProgressIndicator(color: AppColors.colTertiary)),
      );
    }

    // 2. Handle Empty State (CRITICAL FIX)
    if (birds.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.colBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: AppColors.colPrimary),
              const SizedBox(height: AppSizes.sizeMedium),
              const Text("No birds found for this level.", style: AppTypography.subtitle1),
              const SizedBox(height: AppSizes.sizeMedium),
              AppButton(
                  label: "Go Back",
                  variant: AppButtonVariant.ghost,
                  onPressed: widget.onQuit
              ),
            ],
          ),
        ),
      );
    }
    // 3. Now safe to access birds[currentIndex]
    final currentBird = birds[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.colBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/appBg1.webp"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.colBackground.withOpacity(0.7),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
            child: Column(
              children: [
                // Header Pankhs Quiz
                _buildTopHeader(),
                const SizedBox(height: AppSizes.sizeSmall),

                // Progress Section using AppProgress
                Row(
                  children: [
                    WidQuizHelper.infoChip("$currentIndex / ${birds.length}"),
                    const SizedBox(width: AppSizes.sizeSmall),
                    Expanded(
                      child: AppProgress(
                        value: (currentIndex) / birds.length,
                        thickness: AppSizes.sizeXSmall,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sizeSmall),
                    ValueListenableBuilder<Duration>(
                      valueListenable: _timerNotifier,
                      builder: (context, time, _) => WidQuizHelper.infoChip(WidQuizHelper.formatTime(time)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sizeSmall),
                const SizedBox(height: AppSizes.sizeSmall),

                // Media Card
                Column(
                  children: [
                    AppCard(
                      height: 250,
                      width: double.infinity,
                      title : "Need a hint?",
                      expandedText: hints.first,
                      customBody: Stack(
                        children: [
                          _buildMediaContent(currentBird),
                          // Error Overlay
                          IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              opacity: _isWrong ? 0.4 : 0.0,
                              child: Container(color: AppColors.colRed, width: double.infinity, height: double.infinity),
                            ),
                          ),
                          //Confetti Effect
                          Positioned(
                            top: 20,
                            left: 170,
                            child: ConfettiWidget(
                              confettiController: _confettiController,
                              blastDirectionality: BlastDirectionality.explosive,
                              shouldLoop: false,
                              particleDrag: 0.05,
                              colors: const [Color(0xFF2D5A27), Color(0xFF8B4513), Color(0xFFD4AF37), Color(0xFF4682B4)],
                              numberOfParticles: 50,
                              gravity: 0.9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // if (isQuizStarted)
                //   WidQuizHelper.hintCarousel(
                //     currentIndex: currentHintIndex,
                //     totalHints: hints.length,
                //     onPrevious: () => setState(() => currentHintIndex = (currentHintIndex > 0) ? currentHintIndex - 1 : hints.length - 1),
                //     onNext: () => setState(() => currentHintIndex = (currentHintIndex + 1) % hints.length),
                //   ),
                const SizedBox(height: AppSizes.sizeSmall),
                // Options Area
                Expanded(
                  child: isQuizStarted
                      ? _buildOptionsArea()
                      : WidQuizHelper.buildBigCounter(countdown),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(
            "PANKH QUIZ",
            style: AppTypography.subtitle1.copyWith(color: AppColors.colPrimary, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.colPrimary, size: 28),
            onPressed: () => WidDialog.showExitConfirmation(context),
          ),
        ],
      );
  }

  Widget _buildMediaContent(ModBird bird) {
    debugPrint("bird: ${bird.birdName}, featuredImage: ${bird.featuredImage.imageURL}");
    if (currentType == QuestionType.image) {
      return Image.network(
        bird.featuredImage.imageURL,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: AppColors.colSecondary),
      );
    } else {
      return WidQuizHelper.buildAudioUI(
        controller: _waveformController,
        onReplay: () => _playBirdSound(bird.birdAudios[0].audioURL),
      );
    }
  }

  Widget _buildOptionsArea() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppSizes.sizeMedium, 0, AppSizes.sizeMedium, AppSizes.sizeMedium),
      child: WidQuizOptions(
        options: _currentQuestionOptions,
        optionSize: currentType.optionSize,
        onOptionSelected: (selectedName) => _handleAnswer(selectedName),
      ),
    );
  }

  List<Map<String, String>> _generateOptions() {
    final correctBird = birds[currentIndex];
    List<ModBird> others = birds.where((b) => b.birdName != correctBird.birdName).toList();
    others.shuffle();
    List<ModBird> quizOptions = [correctBird, ...others.take(3)]..shuffle();
    return quizOptions.map((b) => {"name": b.birdName, "image": b.featuredImage.imageURL}).toList();
  }

  Future<String> _downloadAndGetPath(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${url.split('/').last}');
      if (await file.exists()) return file.path;
      await Dio().download(url, file.path);
      return file.path;
    } catch (e) {
      return "";
    }
  }

}