class QuizSessionModel {
  final int? id;
  final int userId;
  final String language;
  final String? topic;
  final String? difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int xpEarned;
  final int timeTakenSeconds;
  final String completedAt;

  QuizSessionModel({
    this.id,
    required this.userId,
    required this.language,
    this.topic,
    this.difficulty,
    required this.totalQuestions,
    this.correctAnswers = 0,
    this.xpEarned = 0,
    this.timeTakenSeconds = 0,
    required this.completedAt,
  });

  factory QuizSessionModel.fromMap(Map<String, dynamic> map) {
    return QuizSessionModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      language: map['language'] as String,
      topic: map['topic'] as String?,
      difficulty: map['difficulty'] as String?,
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int? ?? 0,
      xpEarned: map['xp_earned'] as int? ?? 0,
      timeTakenSeconds: map['time_taken_seconds'] as int? ?? 0,
      completedAt: map['completed_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'language': language,
      'topic': topic,
      'difficulty': difficulty,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'xp_earned': xpEarned,
      'time_taken_seconds': timeTakenSeconds,
      'completed_at': completedAt,
    };
  }

  double get accuracyPercent =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
}