import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

// Internal Project Imports
import 'package:pankh/constants/appTokens.dart';
import 'package:pankh/models/modBird.dart';
import 'package:pankh/widgets/widQuizHelper.dart';
import 'package:pankh/widgets/widQuizOptions.dart';
import 'package:pankh/widgets/uihelper.dart';

import '../../services/serBird.dart';



class QuizScreen extends StatefulWidget {
  final VoidCallback onQuit;
  final String difficulty;
  const QuizScreen({super.key, required this.onQuit, required this.difficulty});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // --- Services & Controllers ---
  final AudioPlayer _audioPlayer = AudioPlayer(); // For logic
  late PlayerController _waveformController; // For visuals
  late ConfettiController _confettiController;
  static final Dio _dio = Dio();

  // --- State Variables ---
  List<modBird> birds = [];
  bool isLoading = true;
  int currentIndex = 0;
  int correctCount = 0;
  int currentHintIndex = 0;
  int countdown = 3;
  bool isQuizStarted = false;
  QuestionType currentType = QuestionType.image;
  List<String> hints = [];


  // --- Timers & Notifiers ---
  final ValueNotifier<Duration> _timerNotifier = ValueNotifier(const Duration(minutes: 2));
  Timer? _countdownTimer;
  Timer? _quizTimer;

  @override
  void initState() {
    super.initState();
    _waveformController = PlayerController();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _initializeQuiz();

  }

  // ==========================================
  // LOGIC & STATE MANAGEMENT
  // ==========================================

  Future<void> _initializeQuiz() async {
    correctCount = 0;
    if (mounted) {
      setState(() => isLoading = true);
      try {
        final data = await BirdService.getBirds(limitRows:5, filterColumn:"urbanOccurance",filterValue: widget.difficulty);
        setState(() {

          isLoading = false;
          birds = data;
        });
      } catch (e) {print("Error fetching birds: $e");}
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
        _prepareQuestionMedia(); // Play sound immediately if first question is audio
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
      "Lore: ${bird.folkStory}",
      "Habitat: ${bird.habitat}",
      "Order: ${bird.order}",
      "Hindi name: ${bird.hindiName}",
      "Marathi name: ${bird.marathiName}",
      "Personal Observation: ${bird.personalObservation}",
    ];
    if (currentType == QuestionType.audio && birds.isNotEmpty) {
      _playBirdSound(bird.gitAudio[0]);
    }
  }

  Future<void> _playBirdSound(String url) async {
    if (url.isEmpty) return;
    try {
      // 1. Stop any current playback and download and get URL file
      await _waveformController.stopPlayer();
      String localPath = await _downloadAndGetPath(url);
      await _waveformController.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
      );

      // 2. Start playback
      await _waveformController.startPlayer();
    } catch (e) {
      debugPrint("Playback Error: $e");
      // FALLBACK: If waveform player fails, use the standard audioPlayer
      await _audioPlayer.play(UrlSource(url));
    }
  }

  void _handleAnswer(String selectedName) {
    _waveformController.stopPlayer(); // Stop sound when answered

    if (selectedName == birds[currentIndex].birdName) {
      _confettiController.play();
      setState(() => correctCount++);
    }

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

    // 1. Call the helper and WAIT for the user's choice
    final String? action = await WidQuizHelper.showResults(
        context,
        correctCount,
        birds.length
    );

    // 2. Handle the choice here where the state lives
    if (action == "restart") {
      // Reset variables so the UI looks fresh
      setState(() {
        currentIndex = 0;
        correctCount = 0;
        currentHintIndex = 0;
        countdown = 3;
        isQuizStarted = false;
        _timerNotifier.value = const Duration(minutes: 2);
      });

      // Call your init method to fetch new birds
      _initializeQuiz();

    } else if (action == "exit") {
      widget.onQuit(); // This calls the Navigator.pop(context) you passed in
    }
  }

// Add this helper to clean up the state before restarting
  void _resetGameState() {
    setState(() {
      currentIndex = 0;
      correctCount = 0;
      currentHintIndex = 0;
      countdown = 3;
      isQuizStarted = false;
      _timerNotifier.value = const Duration(minutes: 2); // Reset timer
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _quizTimer?.cancel();
    _audioPlayer.dispose();
    _waveformController.dispose();
    _confettiController.dispose();
    _timerNotifier.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  // ==========================================
  // UI BUILDERS
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              _buildTopHeader(),



              // Progress Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    WidQuizHelper.infoChip("$correctCount / ${birds.length}"),
                    const SizedBox(width: 10),
                    Expanded(child: WidQuizHelper.progressBar(currentIndex, birds.length)),
                    const SizedBox(width: 10),
                    ValueListenableBuilder<Duration>(
                      valueListenable: _timerNotifier,
                      builder: (context, time, _) =>
                          WidQuizHelper.infoChip(WidQuizHelper.formatTime(time)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Media Stage (Image or Audio)
              WidQuizHelper.buildMediaWrapper(
                isQuizStarted: isQuizStarted,
                mediaWidget: _buildMediaContent(birds[currentIndex]),
              ),

              const SizedBox(height: 20),

              // Hint Navigation
              if (isQuizStarted)
                WidQuizHelper.hintCarousel(
                  currentIndex: currentHintIndex,
                  totalHints: hints.length,

                  onPrevious: () => setState(() =>
                  currentHintIndex = (currentHintIndex > 0) ? currentHintIndex - 1 : hints.length - 1
                  ),

                  onNext: () => setState(() =>
                  currentHintIndex = (currentHintIndex + 1) % hints.length
                  ),
                ),

              // Options Grid
              Expanded(
                child: isQuizStarted
                    ? _buildOptionsArea()
                    : WidQuizHelper.buildBigCounter(countdown),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 48), // Spacer to center title
          const Spacer(),
          UiHelper.CustomText(
            text: "Pankh Quiz",
            fontFamily: AppFonts.fontFamilyLogo,
            fontSize: AppFontSizes.fontSizeTitleBig,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => _showExitConfirmation(),
          ),

        ],
      ),
    );
  }

  Widget _buildMediaContent(modBird bird) {
    // 1. Determine the media widget based on currentType
    Widget mediaWidget;

    switch (currentType) {
      case QuestionType.image:
        mediaWidget = Image.network(
          bird.gitImageURL,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 50, color: Colors.white54),
        );
        break;

      case QuestionType.audio:
        mediaWidget = WidQuizHelper.buildAudioUI(
          controller: _waveformController,
          onReplay: () => _playBirdSound(bird.gitAudio[0]),
        );
        break;

    // Add future cases here, e.g., QuestionType.video:
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // media based on QuestionType
        mediaWidget,

        // Confetti Layer
        Positioned(
          top: 0,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            createParticlePath: WidQuizHelper.drawFeather,
            particleDrag: 0.05,
            colors: const [Color(0xFF2D5A27), Color(0xFF8B4513), Color(0xFFD4AF37), Color(0xFF4682B4)],
            numberOfParticles: 50,
            gravity: 0.9,
          ),
        ),

        // Hint Overlay
        if (isQuizStarted) WidQuizHelper.hintOverlay(hints[currentHintIndex]),
      ],
    );
  }

  Widget _buildOptionsArea() {
    // Generate the 4 options for this specific question
    final currentOptions = _generateOptions();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: WidQuizOptions(
        options: currentOptions, // Now only 4 birds (1 correct, 3 wrong)
        optionSize: currentType.optionSize,
        onOptionSelected: (selectedName) => _handleAnswer(selectedName),
      ),
    );
  }

  List<Map<String, String>> _generateOptions() {
    final correctBird = birds[currentIndex];

    // 1. Create a list of all birds EXCEPT the correct one
    List<modBird> others = birds.where((b) => b.birdName != correctBird.birdName).toList();

    // 2. Shuffle the 'others' and take 3
    others.shuffle();
    List<modBird> distractors = others.take(3).toList();

    // 3. Combine correct bird + 3 distractors
    List<modBird> quizOptions = [correctBird, ...distractors];

    // 4. Shuffle again so the correct answer isn't always at index 0
    quizOptions.shuffle();

    return quizOptions.map((b) => {
      "name": b.birdName,
      "image": b.gitImageURL,
    }).toList();
  }

  Future<void> _showExitConfirmation() async {
    final bool? quit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quit Quiz?"),
        content: const Text("Your current progress will be lost."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("STAY")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("QUIT")),
        ],
      ),
    );
    if (quit == true) widget.onQuit();
  }

// Inside _QuizScreenState
  Future<String> _downloadAndGetPath(String url) async {
    if (url.isEmpty) return "";

    try {
      // 1. Get the system temp directory
      final dir = await getTemporaryDirectory();

      // 2. Create a unique filename based on the URL to prevent redundant downloads
      // This extracts the last part of the URL (e.g., 'house_sparrow_song.mp3')
      final String fileName = url.split('/').last;
      final file = File('${dir.path}/$fileName');

      // 3. Check if file already exists (Cache hit)
      if (await file.exists()) {
        debugPrint("Audio Cache Hit: $fileName");
        return file.path;
      }

      // 4. Download only if it doesn't exist (Cache miss)
      debugPrint("Audio Cache Miss: Downloading $fileName...");
      await Dio().download(url, file.path);

      return file.path;
    } catch (e) {
      debugPrint("Download Error: $e");
      return ""; // Handle failure gracefully
    }
  }
}