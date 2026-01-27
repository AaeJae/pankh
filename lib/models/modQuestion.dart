enum QuestionType { image, sound }

class Question {
  final String id;
  final QuestionType type;
  final String birdName;
  final String mediaUrl; // Image URL or Audio URL
  final List<String> options; // Shuffle these elsewhere

  Question({
    required this.id,
    required this.type,
    required this.birdName,
    required this.mediaUrl,
    required this.options,
  });
}