class TopicProgressModel {
  final int? id;
  final int userId;
  final String language;
  final String topic;
  final int totalAttempted;
  final int totalCorrect;
  final String masteryLevel;
  final String? lastPracticed;

  TopicProgressModel({
    this.id,
    required this.userId,
    required this.language,
    required this.topic,
    this.totalAttempted = 0,
    this.totalCorrect = 0,
    this.masteryLevel = 'beginner',
    this.lastPracticed,
  });

  factory TopicProgressModel.fromMap(Map<String, dynamic> map) {
    return TopicProgressModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      language: map['language'] as String,
      topic: map['topic'] as String,
      totalAttempted: map['total_attempted'] as int? ?? 0,
      totalCorrect: map['total_correct'] as int? ?? 0,
      masteryLevel: map['mastery_level'] as String? ?? 'beginner',
      lastPracticed: map['last_practiced'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'language': language,
      'topic': topic,
      'total_attempted': totalAttempted,
      'total_correct': totalCorrect,
      'mastery_level': masteryLevel,
      'last_practiced': lastPracticed,
    };
  }

  double get correctRate =>
      totalAttempted > 0 ? (totalCorrect / totalAttempted) * 100 : 0;

  String get calculatedMastery {
    if (totalAttempted < 5) return 'beginner';
    if (correctRate >= 80) return 'expert';
    if (correctRate >= 50) return 'intermediate';
    return 'beginner';
  }

  TopicProgressModel copyWith({
    int? totalAttempted,
    int? totalCorrect,
    String? masteryLevel,
    String? lastPracticed,
  }) {
    return TopicProgressModel(
      id: id,
      userId: userId,
      language: language,
      topic: topic,
      totalAttempted: totalAttempted ?? this.totalAttempted,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      lastPracticed: lastPracticed ?? this.lastPracticed,
    );
  }
}