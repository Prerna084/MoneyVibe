enum TraitCategory { planning, impulse, risk, calmness }

class Question {
  final String id;
  final String text;
  final TraitCategory category;

  Question({required this.id, required this.text, required this.category});
}

class QuizResult {
  final String persona;
  final Map<TraitCategory, double> scores;
  final List<String> insights;
  final DateTime timestamp;
  final String powerColor; // NEW: Dynamic color from Gemini
  final String secondaryColor; // NEW: Accent color from Gemini
  final String serialNumber; // NEW: Access key

  QuizResult({
    required this.persona,
    required this.scores,
    required this.insights,
    required this.timestamp,
    required this.powerColor,
    required this.secondaryColor,
    required this.serialNumber,
  });
}
