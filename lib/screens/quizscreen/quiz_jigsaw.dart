import 'dart:async';
import 'package:flutter/material.dart';

// Assuming colPrimary is defined in your constants
const Color colPrimary = Color(0xFF075E54); // Replace with your actual colPrimary

class QuizJigsawScreen extends StatefulWidget {
  const QuizJigsawScreen({super.key});

  @override
  State<QuizJigsawScreen> createState() => _QuizJigsawScreenState();
}

class _QuizJigsawScreenState extends State<QuizJigsawScreen> {
  final String imageUrl = "assets/images/Asian Openbill_wiki_9.png";
  final int gridSize = 3;

  List<int> board = [];
  bool isReady = false;
  Size? boardSize;

  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    board = List.generate(gridSize * gridSize, (i) => i);
    _initializePuzzle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  Future<void> _initializePuzzle() async {
    final Image image = Image.asset(imageUrl);
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

    setState(() {
      boardSize = Size(width, height);
      _shuffleBoard();
      isReady = true;
    });
  }

  void _shuffleBoard() {
    setState(() {
      board.shuffle();
      _startTimer();
    });
  }

  void _handleTap(int index) {
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
      _timer?.cancel();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Magnificent!"),
          content: Text("Completed in ${_formatTime(_secondsElapsed)}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _shuffleBoard();
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  // Styled InfoChip following your wid_quizhelper pattern
  Widget _buildTimerChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 18, color: colPrimary),
          const SizedBox(width: 8),
          Text(
            _formatTime(_secondsElapsed),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    double tileW = boardSize!.width / gridSize;
    double tileH = boardSize!.height / gridSize;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Bird Slide Puzzle"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shuffleBoard,
          ),
        ],
      ),
      body: SizedBox.expand( // Ensures the center logic uses full screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertical Center
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontal Center
          children: [
            _buildTimerChip(),
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
                                  child: Image.asset(
                                    imageUrl,
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
    );
  }
}