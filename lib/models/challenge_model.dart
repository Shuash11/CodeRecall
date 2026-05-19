class ChallengeModel {
  final int? id;
  final String language;
  final String type;
  final String topic;
  final String difficulty;
  final String questionText;
  final String? codeSnippet;
  final String correctAnswer;
  final String explanation;
  final int xpReward;

  ChallengeModel({
    this.id,
    required this.language,
    required this.type,
    required this.topic,
    required this.difficulty,
    required this.questionText,
    this.codeSnippet,
    required this.correctAnswer,
    required this.explanation,
    this.xpReward = 10,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'] as int?,
      language: map['language'] as String,
      type: map['type'] as String,
      topic: map['topic'] as String,
      difficulty: map['difficulty'] as String,
      questionText: map['question_text'] as String,
      codeSnippet: map['code_snippet'] as String?,
      correctAnswer: map['correct_answer'] as String,
      explanation: map['explanation'] as String,
      xpReward: map['xp_reward'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'language': language,
      'type': type,
      'topic': topic,
      'difficulty': difficulty,
      'question_text': questionText,
      'code_snippet': codeSnippet,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'xp_reward': xpReward,
    };
  }
}