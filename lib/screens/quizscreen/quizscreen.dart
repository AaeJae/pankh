import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import 'package:pankh/constants/appDesignSystem.dart';
import '../../services/ser_quiz.dart';
import '../../widgets/widDialog.dart';
import '../../widgets/widQuizHelper.dart';
import '../../widgets/widQuizOptionHelper.dart';

class QuizScreen extends StatefulWidget {
  final String? quizTitle;
  final int? quizDurationMins;
  final int? quizTotalQuestions;
  final Map<String, dynamic>? quizFilters;
  final Map<String, dynamic>? birdFilters;

  final VoidCallback onQuit;
  const QuizScreen({super.key,
    this.quizTitle = "Quiz",
    this.quizDurationMins = 2,
    this.quizTotalQuestions = 10,
    this.quizFilters = const {'isStandalone': false},
    this.birdFilters = const {'hasImage': true},
    required this.onQuit});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late SerQuiz _quizLogic;
  late ConfettiController _confetti;
  bool _isLoading = true;
  bool _isWrong = false;

  @override
  void initState() {
    super.initState();
    debugPrint("inside QuizScreen initState():quizTitle: ${widget.quizTitle}, quizTotalQuestions: ${widget.quizTotalQuestions}, quizDurationMins: ${widget.quizDurationMins},");
    _quizLogic = SerQuiz(quizDurationMins: widget.quizDurationMins, quizTotalQuestions: widget.quizTotalQuestions, quizFilters: widget.quizFilters, birdFilters: widget.birdFilters, );
    _quizLogic.onFinishCallback = _onFinish;
    _confetti = ConfettiController(duration: const Duration(milliseconds: 1000));
    _init();
  }

  void _init() async {
    await _quizLogic.setupQuiz();
    if (!mounted) return;
    setState(() => _isLoading = false);
    _quizLogic.startCountdown(
      onTick: () => setState(() {}),
      onFinished: () {
        setState(() {_quizLogic.startTimer(onTimeUp: _onFinish);});
      },
    );
  }


  void _onAnswer(String name) {
    _quizLogic.waveformController.stopPlayer();
    if (name == _quizLogic.currentBirds[_quizLogic.currentBirdIndex].birdName) {
      _confetti.play();
      _quizLogic.correctCount++;
      Future.delayed(const Duration(milliseconds: 600), () { setState(() { _quizLogic.next(); }); });
    } else {
      setState(() => _isWrong = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isWrong = false);
          _quizLogic.next();
        }
      });
    }
  }

  void _onFinish() async {
    setState(() {});
    final action = await WidDialog.showResults(
      context,
      title: "Quiz Complete!",
      correct: _quizLogic.correctCount,
      total: _quizLogic.currentBirds.length,
      isGuest: false,
    );
    action == "restart"
        ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => QuizScreen(
                quizTitle: widget.quizTitle!,
                quizTotalQuestions: widget.quizTotalQuestions!,
                quizDurationMins: widget.quizDurationMins!,
                quizFilters: widget.quizFilters,
                birdFilters: widget.birdFilters,
                onQuit: () => Navigator.pop(context),
              ),
            ),
          )
        : widget.onQuit();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

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
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenEdge,),
            child: Column(
              children: [
                // PANKH QUIZ
                WidQuizHelper.buildTopHeader(context, widget.quizTitle!),
                const SizedBox(height: AppSizes.sizeSmall),

                // PROGRESS BAR
                WidQuizHelper.buildProgressBar(_quizLogic.currentBirdIndex, _quizLogic.currentBirds.length, _quizLogic.timerNotifier),

                // MEDIA CARD
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_quizLogic.isQuizStarted
                      ?  AppCard(
                        height: 250,
                        width: double.infinity,
                        title : "Need a hint?",
                        expandedText: _quizLogic.getHints(),
                        customBody: Center(
                          child: Stack(
                            children: [
                              // Question card
                              WidQuizHelper.buildMediaContent(
                                bird: _quizLogic.currentBirds[_quizLogic.currentBirdIndex],
                                currentQuizType: _quizLogic.currentQuizType!,
                                controller: _quizLogic.waveformController,
                                onReplay: _quizLogic.playCurrentAudio,
                              ),
                              // Wrong answer: Error overlay
                              if (_isWrong) Container(color: Colors.red.withOpacity(0.4)),
                              // Correct answer: Confetti Overlay
                              //Align(alignment: Alignment.topCenter,child: ConfettiWidget(confettiController: _confetti)),
                              Positioned(
                                top: 0,
                                left: 200,
                                child: ConfettiWidget(
                                  confettiController: _confetti,
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
                      )
                      : WidQuizHelper.buildBigCounter(_quizLogic.countdown),
                      Text("${_quizLogic.currentQuizType}; ${_quizLogic.currentOptionsType};"),
                    ],
                  ),
                ),
                if (_quizLogic.isQuizStarted)
                  Expanded(
                    child: WidQuizOptions(
                    options: _quizLogic.currentOptions,
                    optionSize: _quizLogic.currentOptionsType!,
                    onOptionSelected: _onAnswer,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quizLogic.dispose();
    _confetti.dispose();
    super.dispose();
  }
}
