import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pankh/services/ser_bird.dart';

import '../../constants/appDesignSystem.dart';
import '../../widgets/widDialog.dart';
import '../../widgets/widQuizHelper.dart';

// Assuming colPrimary is defined in your constants
const Color colPrimary = Color(0xFF075E54); // Replace with your actual colPrimary

class QuizPuzzleScreen extends StatefulWidget {
  final String? quizTitle;
  final int? quizDurationMins;
  final int? quizTotalQuestions;
  final Map<String, dynamic>? quizFilters;
  final Map<String, dynamic>? birdFilters;
  final VoidCallback onQuit;

  const QuizPuzzleScreen({super.key,
    this.quizTitle = "Quiz",
    this.quizDurationMins = 2,
    this.quizTotalQuestions = 10,
    this.quizFilters = const {'isStandalone': false},
    this.birdFilters = const {'hasImage': true},
    required this.onQuit});

  @override
  State<QuizPuzzleScreen> createState() => _QuizPuzzleScreenState();
}

class _QuizPuzzleScreenState extends State<QuizPuzzleScreen> {

  // State Variables
  bool _isLoading = true;
  bool gameEnded = false;
  bool isReady = false;
  int moves = 0;

  // Timer State
  Timer? _gameTimer;
  late ValueNotifier<Duration> _elapsedNotifier;

  // Game Data
  late String birdImage = "assets/images/Asian Openbill_wiki_9.png";
  final int gridSize = 3;
  Size? boardSize;
  List<int> board = [];


  @override
  void initState() {
    super.initState();
    _elapsedNotifier = ValueNotifier(Duration.zero);
    board = List.generate(gridSize * gridSize, (i) => i);
    _initializePuzzle();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !gameEnded) {
        _elapsedNotifier.value = Duration(seconds: timer.tick);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _initializePuzzle() async {
    final birds = SerBird.getBirds(limitRows: 10, filters: widget.birdFilters);
    if (birds.isEmpty) return;
    final targetModBird = (List.from(birds)..shuffle()).first;

    final String remoteUrl = targetModBird.birdImages.first.imageURL;
    final Image image = Image.network(remoteUrl);

    final Completer<Size> completer = Completer();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        if (!completer.isCompleted) {
          completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
        }
      }),
    );

    final Size originalSize = await completer.future;
    if (!mounted) return;

    final screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.9;
    double height = width / (originalSize.width / originalSize.height);
    debugPrint("width: $width, height: $height");
    setState(() {
      birdImage = remoteUrl;
      boardSize = Size(width, height);
      _shuffleBoard();
      isReady = true;
      _isLoading = false;
    });

  }


  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }


  void _shuffleBoard() {
    setState(() {
      board.shuffle();
      _startTimer();
    });
  }

  void _handleTap(int index) {
    moves = moves + 1;
    int emptyIndex = board.indexOf(gridSize * gridSize - 1);
    int row = index ~/ gridSize;
    int col = index % gridSize;
    int emptyRow = emptyIndex ~/ gridSize;
    int emptyCol = emptyIndex % gridSize;

    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      setState(() {
        board[emptyIndex] = board[index];
        board[index] = gridSize * gridSize - 1;
      });
      _checkVictory();
    }
  }

  void _checkVictory() {
    if (board.asMap().entries.every((e) => e.value == e.key)) {
      gameEnded = true;
      _gameTimer?.cancel();
      _onFinish();
    }
  }
  void _onFinish() async {
    setState(() {});
    final action = await WidDialog.showResults(
      context,
      title: "Puzzle Solved!",
      scoreText: "Solved in $moves moves in ${WidQuizHelper.formatTime(_elapsedNotifier.value)}",
      isGuest: false, // Explicitly naming this as well
    );
    action == "restart"
        ? _initializePuzzle()
        : widget.onQuit();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || boardSize == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    double tileW = boardSize!.width / gridSize;
    double tileH = boardSize!.height / gridSize;

    return Scaffold(
      backgroundColor: AppColors.colBackground,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/appBg1.webp"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(AppColors.colBackground.withOpacity(0.65), BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge),
            child: Column(
              children: [
                // FEATHER SHUFFLE QUIZ
                WidQuizHelper.buildTopHeader(context, widget.quizTitle!),
                const SizedBox(height: AppSizes.sizeSmall),

                // PROGRESS AREA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // PROGRESS BAR
                    WidQuizHelper.infoChip("Moves: ${moves.toString()}"),

                    ValueListenableBuilder<Duration>(
                      valueListenable: _elapsedNotifier,
                      builder: (context, time, _) => WidQuizHelper.infoChip(WidQuizHelper.formatTime(time)),
                    ),
                  ],
                ),

                // PUZZLE GRID
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Vertical Center
                      crossAxisAlignment: CrossAxisAlignment.center, // Horizontal Center
                      children: [

                        const SizedBox(height: 30),

                        // Parent container with rounded corners and colPrimary
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: colPrimary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colPrimary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: boardSize!.width,
                              height: boardSize!.height,
                              color: Colors.white10, // Subtle inner background
                              child: Stack(
                                children: List.generate(board.length, (index) {
                                  int tileId = board[index];
                                  if (tileId == gridSize * gridSize - 1) return const SizedBox.shrink();

                                  int originalRow = tileId ~/ gridSize;
                                  int originalCol = tileId % gridSize;
                                  int currentRow = index ~/ gridSize;
                                  int currentCol = index % gridSize;

                                  return AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    left: currentCol * tileW,
                                    top: currentRow * tileH,
                                    child: GestureDetector(
                                      onTap: () => _handleTap(index),
                                      child: Container(
                                        width: tileW,
                                        height: tileH,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white24, width: 0.5),
                                        ),
                                        child: ClipRect(
                                          child: OverflowBox(
                                            alignment: Alignment.topLeft,
                                            maxWidth: boardSize!.width,
                                            maxHeight: boardSize!.height,
                                            child: Transform.translate(
                                              offset: Offset(-originalCol * tileW, -originalRow * tileH),
                                              child: Image.network(
                                                birdImage,
                                                width: boardSize!.width,
                                                height: boardSize!.height,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Arrange the pieces to reveal the bird",
                          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}