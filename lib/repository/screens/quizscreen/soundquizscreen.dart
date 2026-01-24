import 'dart:async';
import 'package:flutter/material.dart';
import '../../../widgets/quizoptions.dart';
import '../../../widgets/uihelper.dart';
import 'package:pankh/domain/constants/appColors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../widgets/widheader.dart';
import '../../../widgets/widBotMenu.dart';

class SoundQuizScreen extends StatefulWidget {
  const SoundQuizScreen({super.key});

  @override
  State<SoundQuizScreen> createState() => _SoundQuizScreenState();
}

class _SoundQuizScreenState extends State<SoundQuizScreen> {
  // Logic Variables
  int countdown = 3;
  bool isQuizStarted = false;
  Duration quizDuration = const Duration(minutes: 2);
  Timer? _countdownTimer;
  Timer? _quizTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, String>> birdData = [
    {"name": "Indian Roller", "image": "assets/images/roller.jpg"},
    {"name": "Orange Minivet", "image": "assets/images/minivet.jpg"},
    {"name": "House Sparrow", "image": "assets/images/sparrow.jpg"},
    {"name": "Hummingbird", "image": "assets/images/hummingBird.png"},
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
        _startQuizLogic(); // Starts Audio and 2:00 timer simultaneously
      }
    });
  }

  void _startQuizLogic() {
    // 1. Play Audio immediately
    _audioPlayer.play(AssetSource('audio/audioBirds/audRedVentedBulbul.mp3'));

    // 2. Start the 2:00 timer exactly when countdown ends
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
          // 1. GREEN BACKGROUND: Flush top, ends at 50%
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: UiHelper.CustomSvg(img: "svgBgGreenPlains.svg", height: screenHeight*0.5, fit: BoxFit.cover,)
          ),

          // 2. DYNAMIC CONTENT AREA
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate a responsive width (e.g., 90% of screen width)
              double responsiveWidth = constraints.maxWidth;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Shift down so purple coincides with background seam
                    SizedBox(height: (screenHeight * 0.35)),

                    // THE CONSOLIDATED PLAYER (Responsive Width)
                    SizedBox(
                      width: responsiveWidth,
                      child: _buildGroupedAudioPlayer(),
                    ),

                    //const SizedBox(height: 20),

                    // THE GRID (Matching Responsive Width)
                    SizedBox(
                      width: responsiveWidth,
                      // Use IntrinsicHeight or a fixed ratio for the grid area
                      height: screenHeight * 0.45,
                      child: isQuizStarted
                          ? QuizOptions(
                        options: birdData,
                        size: QuizOptionSize.small, // Switch to .small to see the other version
                        onOptionSelected: (name) {
                          debugPrint("Selected bird: $name");
                        },
                      )
                          : _buildBigCounter(),
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

  //// COUNTER
  Widget _buildBigCounter() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          color: Color(0xFFFDE7AA), // Pale yellow circle
          shape: BoxShape.circle,
        ),
        child: Text(
          "$countdown",
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Color(0xFF6B4FA9)),
        ),
      ),
    );
  }
  //// end COUNTER


  //// GROUPED AUDIO PLAYER
  Widget _buildGroupedAudioPlayer() {
    return Column(
      children: [
        const SizedBox(height: 60), // Offset from Header
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Allows the Pause button to sit half-way out
          children: [
            // 1. THE PURPLE BACKGROUND RECTANGLE
            UiHelper.CustomSvg(img: "svgStyledRect.svg", fit: BoxFit.cover, width: 370),
            // 2. WAVEFORM OVERLAY
            // Using a placeholder graphic that spans the rectangle
            const Positioned(
              child: Icon(Icons.graphic_eq, color: Colors.white60, size: 60),
            ),

            // 3. PROGRESS CHIP (0/5)
            Positioned(
              top: -50,
              left: 0,
              child: _infoChip("0 / 5"),
            ),

            // 4. TIMER CHIP (02:00)
            Positioned(
              top: -50,
              right: 0,
              child: _infoChip(_formatTime(quizDuration)),
            ),

            // 5. PAUSE/PLAY BUTTON: Centered on the top edge
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
                    size: 40,
                    color: const Color(0xFF6B4FA9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper for the translucent chips seen in your design
  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
      ),
      child: UiHelper.CustomText(text: text, color: AppColors.colPurple, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "KantumruyPro"),
    );
  }
  //// end GROUPED AUDIO PLAYER


  String _formatTime(Duration d) =>
      "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";


}