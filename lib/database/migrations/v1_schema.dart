class V1Schema {
  V1Schema._();

  static const String createUsersTable = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      avatar_index INTEGER DEFAULT 0,
      xp INTEGER DEFAULT 0,
      level INTEGER DEFAULT 1,
      streak_days INTEGER DEFAULT 0,
      last_active_date TEXT,
      created_at TEXT NOT NULL
    )
  ''';

  static const String createQuestionsTable = '''
    CREATE TABLE questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      language TEXT NOT NULL,
      type TEXT NOT NULL,
      topic TEXT NOT NULL,
      difficulty TEXT NOT NULL,
      question_text TEXT NOT NULL,
      code_snippet TEXT,
      option_a TEXT,
      option_b TEXT,
      option_c TEXT,
      option_d TEXT,
      correct_answer TEXT NOT NULL,
      explanation TEXT NOT NULL,
      xp_reward INTEGER DEFAULT 10,
      is_seeded INTEGER DEFAULT 1
    )
  ''';

  static const String createQuizSessionsTable = '''
    CREATE TABLE quiz_sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      language TEXT NOT NULL,
      topic TEXT,
      difficulty TEXT,
      total_questions INTEGER NOT NULL,
      correct_answers INTEGER DEFAULT 0,
      xp_earned INTEGER DEFAULT 0,
      time_taken_seconds INTEGER DEFAULT 0,
      completed_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static const String createQuestionAttemptsTable = '''
    CREATE TABLE question_attempts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      question_id INTEGER NOT NULL,
      session_id INTEGER,
      selected_answer TEXT NOT NULL,
      is_correct INTEGER NOT NULL,
      time_taken_seconds INTEGER,
      attempted_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (question_id) REFERENCES questions(id)
    )
  ''';

  static const String createBadgesTable = '''
    CREATE TABLE badges (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      icon_code INTEGER NOT NULL,
      condition_type TEXT NOT NULL,
      condition_value INTEGER NOT NULL,
      is_earned INTEGER DEFAULT 0,
      earned_at TEXT
    )
  ''';

  static const String createTopicProgressTable = '''
    CREATE TABLE topic_progress (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      language TEXT NOT NULL,
      topic TEXT NOT NULL,
      total_attempted INTEGER DEFAULT 0,
      total_correct INTEGER DEFAULT 0,
      mastery_level TEXT DEFAULT 'beginner',
      last_practiced TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  ''';

  static List<String> get allCreateStatements => [
        createUsersTable,
        createQuestionsTable,
        createQuizSessionsTable,
        createQuestionAttemptsTable,
        createBadgesTable,
        createTopicProgressTable,
      ];
}