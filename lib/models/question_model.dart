class QuestionModel {
  final int? id;
  final String language;
  final String type;
  final String topic;
  final String difficulty;
  final String questionText;
  final String? codeSnippet;
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String correctAnswer;
  final String explanation;
  final int xpReward;
  final int isSeeded;

  QuestionModel({
    this.id,
    required this.language,
    required this.type,
    required this.topic,
    required this.difficulty,
    required this.questionText,
    this.codeSnippet,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    required this.correctAnswer,
    required this.explanation,
    this.xpReward = 10,
    this.isSeeded = 1,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] as int?,
      language: map['language'] as String,
      type: map['type'] as String,
      topic: map['topic'] as String,
      difficulty: map['difficulty'] as String,
      questionText: map['question_text'] as String,
      codeSnippet: map['code_snippet'] as String?,
      optionA: map['option_a'] as String?,
      optionB: map['option_b'] as String?,
      optionC: map['option_c'] as String?,
      optionD: map['option_d'] as String?,
      correctAnswer: map['correct_answer'] as String,
      explanation: map['explanation'] as String,
      xpReward: map['xp_reward'] as int? ?? 10,
      isSeeded: map['is_seeded'] as int? ?? 1,
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
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'xp_reward': xpReward,
      'is_seeded': isSeeded,
    };
  }

  List<String> get options {
    return [optionA ?? '', optionB ?? '', optionC ?? '', optionD ?? ''];
  }
}