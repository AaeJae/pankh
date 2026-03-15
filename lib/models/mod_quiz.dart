class ModQuiz {
  final String id;
  final String quizType;
  final List<String>? quizNames;
  final List<String>? quizDescriptions;
  final bool isStandalone;
  final String optionType;
  final int defNumOptions;
  final int defaultTotalQuestions;
  final int defaultDurationMins;
  final int xp;

  ModQuiz({
    required this.id,
    required this.quizType,
    this.quizNames,
    this.quizDescriptions,
    required this.isStandalone,
    required this.optionType,
    required this.defNumOptions,
    required this.defaultTotalQuestions,
    required this.defaultDurationMins,
    required this.xp,
  });

// --- FROM FIRESTORE ---
  factory ModQuiz.fromMap(Map<String, dynamic> data, String documentId) {
    return ModQuiz(
      id: documentId,
      quizType: data['quizType'] ?? 'image',
      // Cast dynamic lists safely into List<String>
      quizNames: (data['quizNames'] as List<dynamic>?)?.cast<String>() ?? ["Quiz"],
      quizDescriptions: (data['quizDescriptions'] as List<dynamic>?)?.cast<String>() ?? ["Try this quiz!"],
      isStandalone: data['isStandalone'] ?? false,
      optionType: data['optionType'] ?? 'small',
      defNumOptions: data['defNumOptions'] ?? 4,
      defaultTotalQuestions: data['defaultTotalQuestions'] ?? 10,
      defaultDurationMins: data['defaultDurationMins'] ?? 2,
      xp: data['xp'] ?? 0,
    );
  }


  // --- TO MAP ---
  Map<String, dynamic> toMap() {
    return {
      'quizType': quizType,
      'quizNames': quizNames,
      'quizDescriptions': quizDescriptions,
      'isStandalone': isStandalone,
      'optionType': optionType,
      'defNumOptions': defNumOptions,
      'defaultTotalQuestions': defaultTotalQuestions,
      'defaultDurationMins': defaultDurationMins,
      'xp': xp,
    };
  }
}
