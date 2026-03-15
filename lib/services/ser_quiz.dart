import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:pankh/models/mod_bird.dart';
import '../../services/ser_bird.dart';
import '../models/mod_quiz.dart';

class SerQuiz {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers and timers
  final PlayerController waveformController = PlayerController();
  late ValueNotifier<Duration> timerNotifier;
  Timer? countdownTimer;
  Timer? quizTimer;

  // State variables
  int countdown = 3;
  int currentBirdIndex = 0;
  int correctCount = 0;
  bool isQuizStarted = false;

  // From QuizScreen
  int quizDurationMins = 2;
  int quizTotalQuestions = 10;
  Map<String, dynamic>? quizFilters;

  // From setupQuiz()
  Future<List<ModQuiz>>? quizTypes; // required quiz types
  Map<String, dynamic>? birdFilters;
  List<ModBird> currentBirds = [];

  // getRandomQuizType() and loadNewQuestion()
  String? currentQuizType; // this very question's quizType
  String? currentOptionsType; // this very questions's optionsType
  List<Map<String, String>> currentOptions = []; // loadNewQuestion()

  // Callback to notify when quiz is finished
  VoidCallback? onFinishCallback;


  SerQuiz({int? quizDurationMins, int? quizTotalQuestions, Map<String, dynamic>? quizFilters, Map<String, dynamic>? birdFilters}) {
    timerNotifier = ValueNotifier(Duration(minutes: quizDurationMins!));
    this.quizTotalQuestions = quizTotalQuestions!;
    this.quizFilters = quizFilters!;
    this.birdFilters = birdFilters!;
    debugPrint("inside SerQuiz(): quizDurationMins: $quizDurationMins, quizTotalQuestions: $quizTotalQuestions, quizFilters: $quizFilters");

  }

  ////////////////////////////////
  // FROM FIRESTORE
  ///////////////////////////////
  static Future<List<ModQuiz>> getQuizzes({Map<String, dynamic>? quizFilters}) async {
    Query query = _firestore.collection('quizzes');
    if (quizFilters != null) {
      quizFilters.forEach((key, value) {
        if (value == null) return;
        if (key == 'quizType' && value is List<String> && value.isNotEmpty) query = query.where(key, whereIn: value);
        else query = query.where(key, isEqualTo: value);
      });
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ModQuiz.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  ////////////////////////////////
  // GETTERS
  ///////////////////////////////

  Future<void> setupQuiz() async {
    quizTypes = getQuizzes(quizFilters: quizFilters!);
    getRandomQuizType(); // set current
    currentBirds = SerBird.getBirds(limitRows: quizTotalQuestions, filters: birdFilters);
    loadNewQuestion(); // set options
  }

  Future<void> getRandomQuizType() async {
    final quizzes = await quizTypes; // resolve the Future<List<ModQuiz>>
    if (quizzes!.isEmpty) {
      currentQuizType = null;
      currentOptionsType = null;
      return;
    }
    final randomQuiz = quizzes[Random().nextInt(quizzes.length)];
    currentQuizType = randomQuiz.quizType;
    currentOptionsType = randomQuiz.optionType;
  }
  String getHints() {
    if (currentBirds.isEmpty) return "";
    final bird = currentBirds[currentBirdIndex];
    return [ "Habitat: ${bird.birdInfo.habitat}", "Order: ${bird.birdInfo.order}", "Hindi name: ${bird.hindiNames}", "Marathi name: ${bird.marathiNames}", "Lore: ${bird.lore}", ].join('\n');
  }

  // --- GENERATE OPTIONS LOGIC ---
  List<Map<String, String>> generateOptions() {
    if (currentBirds.isEmpty) return [];
    final correctBird = currentBirds[currentBirdIndex];
    // Filter out the correct bird to get wrong options
    List<ModBird> wrongOptions = currentBirds.where((b) => b.birdName != correctBird.birdName).toList();
    wrongOptions.shuffle();
    // Take 3 wrong + 1 correct
    List<ModBird> quizChoices = [correctBird, ...wrongOptions.take(3)];
    quizChoices.shuffle();

    return quizChoices.map((b) => {
      "name": b.birdName,
      "image": b.featuredImage.imageURL
    }).toList();
  }

  // --- AUDIO LOGIC ---
  Future<void> playCurrentAudio() async {
    debugPrint("currentBirdIndex: $currentBirdIndex");
    final url = currentBirds[currentBirdIndex].birdAudios[0].audioURL;
    try {
      final path = await _getAudioCache(url);
      await waveformController.preparePlayer(path: path, shouldExtractWaveform: true);
      await waveformController.startPlayer();
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  Future<String> _getAudioCache(String url) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${url.split('/').last}');
    if (!await file.exists()) await Dio().download(url, file.path);
    return file.path;
  }

  /////////////////////////////
  // GAMEPLAY
  ////////////////////////////

  void next() {
    if (currentBirdIndex < currentBirds.length - 1) {
      currentBirdIndex++;
      getRandomQuizType();
      loadNewQuestion();
    } else {
      if (onFinishCallback != null) Future.delayed(Duration.zero, () { onFinishCallback!(); });
    }
  }
  void loadNewQuestion() {
    currentOptions = generateOptions();
    if (currentQuizType == "sound") playCurrentAudio();
  }

  // --- TIMERS ---
  void startCountdown({required VoidCallback onTick, required VoidCallback onFinished}) {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown > 1) { countdown--; onTick(); }
      else { t.cancel(); isQuizStarted = true; onFinished(); }
    });
  }

  void startTimer({required VoidCallback onTimeUp}) {
    quizTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerNotifier.value.inSeconds > 0) {
        timerNotifier.value -= const Duration(seconds: 1);
      } else { t.cancel(); onTimeUp(); }
    });
  }

  void dispose() {
    countdownTimer?.cancel();
    quizTimer?.cancel();
    timerNotifier.dispose();
    waveformController.dispose();
  }
}