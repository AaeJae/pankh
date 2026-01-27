import 'dart:async';
import 'package:flutter/material.dart';
import '../../../widgets/widQuizOptions.dart';
import '../../../widgets/uihelper.dart';
import '../../../widgets/widQuizHelper.dart'; // Import the new helper
import 'package:pankh/constants/appTokens.dart';
import '../../../widgets/widHeader.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundQuizScreen extends StatefulWidget {
  const SoundQuizScreen({super.key});

  @override
  State<SoundQuizScreen> createState() => _SoundQuizScreenState();
}

class _SoundQuizScreenState extends State<SoundQuizScreen> {
  int countdown = 3;
  bool isQuizStarted = false;
  Duration quizDuration = const Duration(minutes: 2);
  Timer? _countdownTimer;
  Timer? _quizTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> birdData = [
    {"name": "Indian Roller", "image": "roller.jpg"},
    {"name": "Orange Minivet", "image": "minivet.jpg"},
    {"name": "House Sparrow", "image": "sparrow.jpg"},
    {"name": "Hummingbird", "image": "hummingBird.png"},
  ];

  @override
  void initState() {
    super.initState();
    _startInitialCountdown();
  }

  void _startInitialCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 1) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        setState(() => isQuizStarted = true);
        _startQuizLogic();
      }
    });
  }

  void _startQuizLogic() {
    _audioPlayer.play(AssetSource('audio/audioBirds/audRedVentedBulbul.mp3'));
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (quizDuration.inSeconds > 0) {
        setState(() => quizDuration -= const Duration(seconds: 1));
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _quizTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const WidHeader(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 1. BACKGROUND
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: UiHelper.CustomSvg(
                img: "svgBgGreenPlains.svg",
                height: screenHeight * 0.5,
                fit: BoxFit.cover,
              )
          ),

          // 2. CONTENT
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: (screenHeight * 0.35)),

                    // PLAYER AREA
                    SizedBox(
                      width: constraints.maxWidth,
                      child: _buildGroupedAudioPlayer(),
                    ),

                    // OPTIONS OR COUNTER
                    SizedBox(
                      width: constraints.maxWidth,
                      height: screenHeight * 0.45,
                      child: isQuizStarted
                          ? WidQuizOptions(
                        options: birdData,
                        size: QuizOptionSize.big,
                        onOptionSelected: (name) => debugPrint(name),
                      )
                          : WidQuizHelper.buildBigCounter(countdown), // Using Helper
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedAudioPlayer() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            UiHelper.CustomSvg(img: "svgStyledRect.svg", fit: BoxFit.cover, width: 370),

            const Positioned(
              child: Icon(Icons.graphic_eq, color: Colors.white60, size: 60),
            ),

            // INFO CHIPS FROM HELPER
            Positioned(
              top: -50,
              left: 0,
              child: WidQuizHelper.infoChip("0 / 5"),
            ),

            Positioned(
              top: -50,
              right: 0,
              child: WidQuizHelper.infoChip(WidQuizHelper.formatTime(quizDuration)),
            ),

            // PAUSE BUTTON
            Positioned(
              top: -55,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    isQuizStarted ? Icons.pause : Icons.play_arrow,
                    size: 40, // Height and Width are handled by 'size' in the native Icon widget
                    color: AppColors.colPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}