class DbConstants {
  DbConstants._();

  // Table names
  static const String tableUsers = 'users';
  static const String tableQuestions = 'questions';
  static const String tableQuizSessions = 'quiz_sessions';
  static const String tableQuestionAttempts = 'question_attempts';
  static const String tableBadges = 'badges';
  static const String tableTopicProgress = 'topic_progress';

  // Users columns
  static const String colUserId = 'id';
  static const String colUsername = 'username';
  static const String colAvatarIndex = 'avatar_index';
  static const String colXp = 'xp';
  static const String colLevel = 'level';
  static const String colStreakDays = 'streak_days';
  static const String colLastActiveDate = 'last_active_date';
  static const String colCreatedAt = 'created_at';

  // Questions columns
  static const String colQuestionId = 'id';
  static const String colLanguage = 'language';
  static const String colType = 'type';
  static const String colTopic = 'topic';
  static const String colDifficulty = 'difficulty';
  static const String colQuestionText = 'question_text';
  static const String colCodeSnippet = 'code_snippet';
  static const String colOptionA = 'option_a';
  static const String colOptionB = 'option_b';
  static const String colOptionC = 'option_c';
  static const String colOptionD = 'option_d';
  static const String colCorrectAnswer = 'correct_answer';
  static const String colExplanation = 'explanation';
  static const String colXpReward = 'xp_reward';
  static const String colIsSeeded = 'is_seeded';

  // Quiz sessions columns
  static const String colSessionId = 'id';
  static const String colSessionUserId = 'user_id';
  static const String colSessionLanguage = 'language';
  static const String colSessionTopic = 'topic';
  static const String colSessionDifficulty = 'difficulty';
  static const String colTotalQuestions = 'total_questions';
  static const String colCorrectAnswers = 'correct_answers';
  static const String colXpEarned = 'xp_earned';
  static const String colTimeTakenSeconds = 'time_taken_seconds';
  static const String colCompletedAt = 'completed_at';

  // Question attempts columns
  static const String colAttemptId = 'id';
  static const String colAttemptUserId = 'user_id';
  static const String colAttemptQuestionId = 'question_id';
  static const String colAttemptSessionId = 'session_id';
  static const String colSelectedAnswer = 'selected_answer';
  static const String colIsCorrect = 'is_correct';
  static const String colAttemptTimeTaken = 'time_taken_seconds';
  static const String colAttemptedAt = 'attempted_at';

  // Badges columns
  static const String colBadgeId = 'id';
  static const String colBadgeName = 'name';
  static const String colBadgeDescription = 'description';
  static const String colIconCode = 'icon_code';
  static const String colConditionType = 'condition_type';
  static const String colConditionValue = 'condition_value';
  static const String colIsEarned = 'is_earned';
  static const String colEarnedAt = 'earned_at';

  // Topic progress columns
  static const String colTpId = 'id';
  static const String colTpUserId = 'user_id';
  static const String colTpLanguage = 'language';
  static const String colTpTopic = 'topic';
  static const String colTotalAttempted = 'total_attempted';
  static const String colTotalCorrect = 'total_correct';
  static const String colMasteryLevel = 'mastery_level';
  static const String colLastPracticed = 'last_practiced';
}